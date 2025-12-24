import 'package:get/get.dart';

import '../../../../core/config/app_config.dart';
import '../../../cashier/presentation/controllers/cashier_controller.dart';
import '../../../product/data/repositories/product_repository.dart';
import '../../../product/presentation/controllers/product_controller.dart';
import '../../data/entities/stock_entity.dart';
import '../../data/repositories/stock_repository.dart';
import '../models/stock_models.dart';

class StockController extends GetxController {
  StockController({
    StockRepository? repository,
    ProductRepository? productRepository,
    AppConfig? config,
  })  : repo = repository ?? Get.find<StockRepository>(),
        _productRepo = productRepository ?? Get.find<ProductRepository>(),
        _config = config ?? Get.find<AppConfig>();

  final StockRepository repo;
  final ProductRepository _productRepo;
  final AppConfig _config;

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
    final qty = int.tryParse(adjustmentValue.value) ?? 0;
    if (qty < 0) return;
    final type = adjustmentType.value!;
    final stockId = int.tryParse(item.id);
    if (stockId == null) return;
    final productId = stockId;
    int newStock = item.stock;
    int delta = 0;

    if (_config.backend == BackendMode.rest && repo.restRemote != null) {
      try {
        switch (type) {
          case StockAdjustmentType.add:
            delta = qty;
            break;
          case StockAdjustmentType.reduce:
            delta = -qty;
            break;
          case StockAdjustmentType.recount:
            delta = qty - item.stock;
            break;
        }
        final adjusted = await repo.adjustRemote(
          stockId: stockId,
          change: qty,
          type: type.name,
          note: note.value.isEmpty ? null : note.value,
          productId: productId,
        );
        if (adjusted != null) {
          newStock = adjusted.stock;
        }
        products.assignAll((await repo.getAll()).map(_map));
      } catch (_) {
        // Queue for sync + optimistic local update.
        await repo.enqueueAdjustment(
          stockId: stockId,
          change: qty,
          type: type.name,
          note: note.value.isEmpty ? null : note.value,
          productId: productId,
        );
        final product = await _productRepo.getById(productId);
        if (product != null) {
          product.stock = (product.stock + delta).clamp(0, 1 << 31);
          await _productRepo.upsert(product);
          newStock = product.stock;
          await _load();
        }
        Get.snackbar('Offline', 'Penyesuaian stok disimpan dan akan disinkronkan.');
      }
    }

    if (_config.backend != BackendMode.rest) {
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
    final stockId = int.tryParse(current.id);
    if (stockId == null) return;

    if (_config.backend == BackendMode.rest && repo.restRemote != null) {
      final remote = await repo.historyRemote(stockId, limit: 50);
      histories.assignAll(
        remote.map(
          (h) => StockHistory(
            date: h['createdAt']?.toString() ?? '',
            status: _statusLabel(
              _typeFromString(h['type']?.toString() ?? ''),
              _toInt(h['change']),
            ),
            quantity: _toInt(h['change']),
            remaining: _toInt(h['remaining']),
            type: _typeFromString(h['type']?.toString() ?? ''),
          ),
        ),
      );
      return;
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
