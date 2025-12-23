import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/network_service.dart';
import '../../../../core/services/activity_log_service.dart';
import '../../data/datasources/product_firestore_data_source.dart';
import '../../data/datasources/product_remote_data_source.dart';
import '../../data/entities/product_entity.dart';
import '../../data/repositories/product_repository.dart';
import '../models/product_models.dart';
import '../../../cashier/presentation/controllers/cashier_controller.dart';
import '../../../management/data/datasources/category_firestore_data_source.dart';
import '../../../management/data/repositories/management_repository.dart';
import '../../../stock/data/entities/stock_entity.dart';
import '../../../stock/data/repositories/stock_repository.dart';
import '../../../stock/presentation/controllers/stock_controller.dart';

class ProductController extends GetxController {
  ProductController({
    ProductRepository? repository,
    ActivityLogService? activityLogService,
    ProductFirestoreDataSource? firebase,
    ProductRemoteDataSource? restRemote,
    CategoryFirestoreDataSource? categoryFirebase,
    ManagementRepository? categoryRepository,
    StockRepository? stockRepository,
    AppConfig? config,
    FirebaseFirestore? firestore,
    NetworkService? network,
  })  : repo = repository ?? Get.find<ProductRepository>(),
        logs = activityLogService ?? Get.find<ActivityLogService>(),
        _config = config ?? Get.find<AppConfig>(),
        _firebase = firebase ??
            ((config ?? Get.find<AppConfig>()).backend == BackendMode.firebase
                ? ProductFirestoreDataSource(firestore ?? FirebaseFirestore.instance)
                : null),
        _rest = restRemote ??
            ((config ?? Get.find<AppConfig>()).backend == BackendMode.rest
                ? ProductRemoteDataSource((network ?? Get.find<NetworkService>()).dio)
                : null),
        _categoryFirebase = categoryFirebase ??
            ((config ?? Get.find<AppConfig>()).backend == BackendMode.firebase
                ? CategoryFirestoreDataSource(firestore ?? FirebaseFirestore.instance)
                : null),
        _categoryRepo = categoryRepository ?? Get.find<ManagementRepository>(),
        _stockRepo = stockRepository ?? Get.find<StockRepository>();

  final ProductRepository repo;
  final ActivityLogService logs;
  final AppConfig _config;
  final ProductFirestoreDataSource? _firebase;
  final ProductRemoteDataSource? _rest;
  final CategoryFirestoreDataSource? _categoryFirebase;
  final ManagementRepository _categoryRepo;
  final StockRepository _stockRepo;

  final Rx<ProductViewMode> viewMode = ProductViewMode.grid.obs;

  final RxList<ProductItem> products = <ProductItem>[].obs;
  final loading = false.obs;
  final RxList<String> categories = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _load();
    _loadCategories();
  }

  Future<void> _load() async {
    loading.value = true;
    final rest = _rest;
    if (_config.backend == BackendMode.rest && rest != null) {
      try {
        final remote = await rest.fetchAll();
        await repo.replaceAll(remote);
        products.assignAll(remote.map(_map));
        await _syncStockFromProducts(remote);
        loading.value = false;
        return;
      } catch (_) {
        // fallback to existing logic below
      }
    }
    final firebase = _firebase;
    if (_config.backend == BackendMode.firebase && firebase != null) {
      try {
        final remote = await firebase.fetchAll();
        await repo.replaceAll(remote);
        products.assignAll(remote.map(_map));
        await _syncStockFromProducts(remote);
      } catch (_) {
        final data = await repo.getAll();
        products.assignAll(data.map(_map));
        await _syncStockFromProducts(data);
      }
    } else {
      final data = await repo.getAll();
      products.assignAll(data.map(_map));
      await _syncStockFromProducts(data);
    }
    loading.value = false;
  }

  Future<void> _loadCategories() async {
    try {
      final categoryFirebase = _categoryFirebase;
      if (_config.backend == BackendMode.firebase && categoryFirebase != null) {
        final remote = await categoryFirebase.fetchAll();
        if (remote.isNotEmpty) {
          categories.assignAll(remote.map((c) => c.name));
          return;
        }
      }
    } catch (_) {}
    try {
      final local = await _categoryRepo.getCategories();
      categories.assignAll(local.map((c) => c.name));
    } catch (_) {
      categories.clear();
    }
  }

  Future<void> refreshRemote() async {
    await _load();
  }

  ProductItem? getById(String id) => products.firstWhereOrNull((p) => p.id == id);

  void setViewMode(ProductViewMode mode) {
    viewMode.value = mode;
  }

  void upsert(ProductItem item) async {
    // Changed to async to await ops
    final index = products.indexWhere((p) => p.id == item.id);
    if (index >= 0) {
      products[index] = item;
    } else {
      products.add(item);
    }
    final entity = _toEntity(item);
    await repo.upsert(entity); // await repo
    final firebase = _firebase;
    if (_config.backend == BackendMode.firebase && firebase != null) {
      try {
        await firebase.upsert(entity);
      } catch (_) {
        // ignore sync failure
      }
    }
    if (Get.isRegistered<CashierController>()) {
      await Get.find<CashierController>().refreshAll();
    }
    final idInt = int.tryParse(item.id) ?? item.id.hashCode;
    if (item.trackStock) {
      final stockEntity = _toStockEntity(entity);
      await _stockRepo.upsert(stockEntity);
    } else {
      // If tracking is turned off, make sure any existing stock record is cleaned up
      try {
        await _stockRepo.delete(idInt);
      } catch (_) {}
    }
    // Refresh stock page if open
    if (Get.isRegistered<StockController>()) {
      await Get.find<StockController>().refreshRemote();
    }
    await _loadCategories();
    logs.add(
      title: index >= 0 ? 'Ubah produk' : 'Tambah produk',
      message: '${item.name} disimpan dengan harga Rp${item.price}',
      actor: 'Manager',
    );
  }

  Future<void> deleteProduct(ProductItem item) async {
    final idInt = int.tryParse(item.id) ?? item.id.hashCode;
    products.removeWhere((p) => p.id == item.id);
    await repo.delete(idInt);
    // Hapus stok apa pun yang tersisa untuk produk ini
    try {
      await _stockRepo.delete(idInt);
    } catch (_) {}
    if (Get.isRegistered<StockController>()) {
      await Get.find<StockController>().refreshRemote();
    }
    if (Get.isRegistered<CashierController>()) {
      await Get.find<CashierController>().refreshAll();
    }
    logs.add(title: 'Hapus produk', message: '${item.name} dihapus', actor: 'Manager');
  }

  ProductItem _map(ProductEntity e) => ProductItem(
    id: e.id.toString(),
    name: e.name,
    category: e.category,
    price: e.price,
    image: e.image,
    trackStock: e.trackStock,
    stock: e.stock,
    minStock: e.minStock,
  );

  ProductEntity _toEntity(ProductItem item) {
    final entity = ProductEntity()
      ..name = item.name
      ..category = item.category
      ..price = item.price
      ..image = item.image
      ..trackStock = item.trackStock
      ..stock = item.stock
      ..minStock = item.minStock;
    entity.id = int.tryParse(item.id) ?? item.id.hashCode;
    return entity;
  }

  StockEntity _toStockEntity(ProductEntity product) {
    final entity = StockEntity()
      ..id = product.id
      ..name = product.name
      ..category = product.category
      ..image = product.image
      ..stock = product.stock
      ..transactions = 0;
    return entity;
  }

  Future<void> _syncStockFromProducts(Iterable<ProductEntity> items) async {
    final trackedIds = <int>{};
    for (final p in items) {
      final id = p.id;
      if (!p.trackStock) {
        // Ensure stock entries are removed for products that should not be tracked
        try {
          await _stockRepo.delete(id);
        } catch (_) {}
        continue;
      }
      trackedIds.add(id);
      await _stockRepo.upsert(_toStockEntity(p));
    }
    // Remove orphaned stock entries for products that no longer exist
    final existingStock = await _stockRepo.getAll();
    for (final s in existingStock) {
      if (!trackedIds.contains(s.id)) {
        try {
          await _stockRepo.delete(s.id);
        } catch (_) {}
      }
    }
    if (Get.isRegistered<StockController>()) {
      await Get.find<StockController>().refreshRemote();
    }
  }
}
