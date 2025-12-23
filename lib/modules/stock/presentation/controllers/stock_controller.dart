import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/network_service.dart';
import '../../../cashier/presentation/controllers/cashier_controller.dart';
import '../../../product/data/repositories/product_repository.dart';
import '../../../product/presentation/controllers/product_controller.dart';
import '../../data/datasources/stock_history_firestore_data_source.dart';
import '../../data/datasources/stock_remote_data_source.dart';
import '../../data/entities/stock_entity.dart';
import '../../data/repositories/stock_repository.dart';
import '../models/stock_models.dart';

class StockController extends GetxController {
  StockController({
    StockRepository? repository,
    ProductRepository? productRepository,
    StockHistoryFirestoreDataSource? historyFirebase,
    StockRemoteDataSource? restRemote,
    AppConfig? config,
    FirebaseFirestore? firestore,
  })  : repo = repository ?? Get.find<StockRepository>(),
        _productRepo = productRepository ?? Get.find<ProductRepository>(),
        _config = config ?? Get.find<AppConfig>(),
        _historyFirebase = historyFirebase ??
            ((config ?? Get.find<AppConfig>()).backend == BackendMode.firebase
                ? StockHistoryFirestoreDataSource(firestore ?? FirebaseFirestore.instance)
                : null),
        _rest = restRemote ??
            ((config ?? Get.find<AppConfig>()).backend == BackendMode.rest
                ? StockRemoteDataSource(Get.find<NetworkService>().dio)
                : null);

  final StockRepository repo;
  final ProductRepository _productRepo;
  final AppConfig _config;
  final StockHistoryFirestoreDataSource? _historyFirebase;
  final StockRemoteDataSource? _rest;

  final RxList<StockItem> products = <StockItem>[].obs;

  final Rx<StockItem?> selected = Rx<StockItem?>(null);
  final RxList<StockHistory> histories = <StockHistory>[].obs;

  final Rx<StockAdjustmentType?> adjustmentType = Rx<StockAdjustmentType?>(null);
  final RxString adjustmentValue = ''.obs;
  final RxString note = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    final rest = _rest;
    if (_config.backend == BackendMode.rest && rest != null) {
      try {
        final data = await rest.fetchAll();
        await repo.replaceAll(data);
        products.assignAll(data.map(_map));
        if (products.isNotEmpty && selected.value == null) {
          selected.value = products.first;
        }
        await _loadHistory();
        return;
      } catch (_) {}
    }

    final data = await repo.getAll();
    products.assignAll(data.map(_map));
    if (products.isNotEmpty && selected.value == null) {
      selected.value = products.first;
    }
    await _loadHistory();
  }

  void pickProduct(StockItem item) {
    selected.value = item;
    _loadHistory();
  }

  void setAdjustmentType(StockAdjustmentType? type) {
    adjustmentType.value = type;
  }

  void setAdjustmentValue(String value) {
    adjustmentValue.value = value;
  }

  void setNote(String value) {
    note.value = value;
  }

  bool get canSubmit =>
      selected.value != null && adjustmentType.value != null && adjustmentValue.value.isNotEmpty;

  Future<void> submitAdjustment() async {
    if (!canSubmit) return;
    final item = selected.value;
    if (item == null) return;
    final rest = _rest;
    final qty = int.tryParse(adjustmentValue.value) ?? 0;
    if (qty < 0) return;
    final type = adjustmentType.value!;
    final productId = int.tryParse(item.id) ?? item.id.hashCode;
    int newStock = item.stock;
    int delta = 0;

    if (_config.backend == BackendMode.rest && rest != null) {
      try {
        final adjusted = await rest.adjust(
          stockId: int.tryParse(item.id) ?? item.id.hashCode,
          change: qty,
          type: type.name,
          note: note.value.isEmpty ? null : note.value,
          productId: productId,
        );
        newStock = adjusted.stock;
        delta = qty;
        final latest = await rest.fetchAll();
        await repo.replaceAll(latest);
        products.assignAll(latest.map(_map));
      } catch (_) {
        // fallback to local adjust below
      }
    }

    if (!(_config.backend == BackendMode.rest && _rest != null)) {
      final product = await _productRepo.getById(productId);
      if (product == null) return;

      switch (type) {
        case StockAdjustmentType.add:
          newStock = product.stock + qty;
          delta = qty;
          break;
        case StockAdjustmentType.reduce:
          newStock = (product.stock - qty).clamp(0, 1 << 31);
          delta = -qty;
          break;
        case StockAdjustmentType.recount:
          delta = qty - product.stock;
          newStock = qty;
          break;
      }

      product.stock = newStock;
      await _productRepo.upsert(product);
      await _load();
    }

    // Refresh other modules that rely on product data
    if (Get.isRegistered<ProductController>()) {
      await Get.find<ProductController>().refreshRemote();
    }
    if (Get.isRegistered<CashierController>()) {
      await Get.find<CashierController>().refreshAll();
    }

    histories.insert(
      0,
      StockHistory(
        date: DateTime.now().toIso8601String(),
        status: _statusLabel(type, delta),
        quantity: delta,
        remaining: newStock,
        type: type,
      ),
    );

    if (_config.backend == BackendMode.firebase && _historyFirebase != null) {
      await _historyFirebase.appendHistory(
        productId: productId,
        change: delta,
        remaining: newStock,
        type: type.name,
        note: note.value.isEmpty ? null : note.value,
      );
    }

    // reset form state
    adjustmentType.value = null;
    adjustmentValue.value = '';
    note.value = '';
  }

  StockItem _map(StockEntity e) => StockItem(
    id: e.id.toString(),
    name: e.name,
    category: e.category,
    image: e.image,
    stock: e.stock,
    transactions: e.transactions,
  );

  Future<void> refreshRemote() => _load();

  Future<void> _loadHistory() async {
    histories.clear();
    final current = selected.value;
    if (current == null) return;
    final productId = int.tryParse(current.id) ?? current.id.hashCode;
    final rest = _rest;

    if (_config.backend == BackendMode.rest && rest != null) {
      try {
        final remote = await rest.history(productId, limit: 50);
        histories.assignAll(
          remote.map(
            (h) => StockHistory(
              date: h['createdAt']?.toString() ?? '',
              status: _statusLabel(_typeFromString(h['type']?.toString() ?? ''), _toInt(h['change'])),
              quantity: _toInt(h['change']),
              remaining: _toInt(h['remaining']),
              type: _typeFromString(h['type']?.toString() ?? ''),
            ),
          ),
        );
        return;
      } catch (_) {}
    }

    if (_config.backend != BackendMode.firebase || _historyFirebase == null) return;
    try {
      final remote = await _historyFirebase.fetchHistory(productId: productId, limit: 50);
      histories.assignAll(
        remote.map(
          (h) => StockHistory(
            date: h.createdAt.toIso8601String(),
            status: _statusLabel(_typeFromString(h.type), h.change),
            quantity: h.change,
            remaining: h.remaining,
            type: _typeFromString(h.type),
          ),
        ),
      );
    } catch (_) {
      // ignore history load errors
    }
  }

  String _statusLabel(StockAdjustmentType type, int delta) {
    switch (type) {
      case StockAdjustmentType.add:
        return 'Penambahan stok';
      case StockAdjustmentType.reduce:
        return 'Pengurangan stok';
      case StockAdjustmentType.recount:
        return 'Hitung ulang (${delta >= 0 ? "+" : ""}$delta)';
    }
  }

  StockAdjustmentType _typeFromString(String value) {
    switch (value) {
      case 'add':
        return StockAdjustmentType.add;
      case 'reduce':
        return StockAdjustmentType.reduce;
      default:
        return StockAdjustmentType.recount;
    }
  }

  int _toInt(dynamic v) => int.tryParse(v?.toString() ?? '') ?? 0;
}
