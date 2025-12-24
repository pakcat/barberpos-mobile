import 'package:get/get.dart';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/network_service.dart';
import '../../../../core/services/activity_log_service.dart';
import '../../../cashier/presentation/controllers/cashier_controller.dart';
import '../../../management/data/repositories/management_repository.dart';
import '../../../stock/data/entities/stock_entity.dart';
import '../../../stock/data/repositories/stock_repository.dart';
import '../../../stock/presentation/controllers/stock_controller.dart';
import '../../data/datasources/product_remote_data_source.dart';
import '../../data/entities/product_entity.dart';
import '../../data/repositories/product_repository.dart';
import '../../data/repositories/product_outbox_repository.dart';
import '../../data/entities/product_outbox_entity.dart';
import '../../data/repositories/product_image_outbox_repository.dart';
import '../models/product_models.dart';

class ProductController extends GetxController {
  ProductController({
    ProductRepository? repository,
    ActivityLogService? activityLogService,
    ProductRemoteDataSource? restRemote,
    ManagementRepository? categoryRepository,
    StockRepository? stockRepository,
    AppConfig? config,
    NetworkService? network,
    ProductOutboxRepository? outboxRepository,
    ProductImageOutboxRepository? imageOutboxRepository,
  }) : repo = repository ?? Get.find<ProductRepository>(),
       logs = activityLogService ?? Get.find<ActivityLogService>(),
       _config = config ?? Get.find<AppConfig>(),
       _rest =
           restRemote ??
           ProductRemoteDataSource((network ?? Get.find<NetworkService>()).dio),
       _categoryRepo = categoryRepository ?? Get.find<ManagementRepository>(),
       _stockRepo = stockRepository ?? Get.find<StockRepository>(),
       _outbox = outboxRepository ?? Get.find<ProductOutboxRepository>(),
       _imageOutbox = imageOutboxRepository ?? Get.find<ProductImageOutboxRepository>();

  final ProductRepository repo;
  final ActivityLogService logs;
  final AppConfig _config;
  final ProductRemoteDataSource _rest;
  final ManagementRepository _categoryRepo;
  final StockRepository _stockRepo;
  final ProductOutboxRepository _outbox;
  final ProductImageOutboxRepository _imageOutbox;

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
    try {
      if (_config.backend == BackendMode.rest) {
        final remote = await _rest.fetchAll();
        await repo.replaceAllFromRemote(remote);
        final merged = await repo.getAll();
        products.assignAll(merged.map(_map));
        await _syncStockFromProducts(merged);
      } else {
        final data = await repo.getAll();
        products.assignAll(data.map(_map));
        await _syncStockFromProducts(data);
      }
    } catch (_) {
      final data = await repo.getAll();
      products.assignAll(data.map(_map));
      await _syncStockFromProducts(data);
    } finally {
      loading.value = false;
    }
  }

  Future<void> _loadCategories() async {
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

  ProductItem? getById(String id) =>
      products.firstWhereOrNull((p) => p.id == id);

  void setViewMode(ProductViewMode mode) {
    viewMode.value = mode;
  }

  void upsert(
    ProductItem item, {
    Uint8List? imageBytes,
    String? imageFilename,
    String? imageMimeType,
  }) async {
    final isRest = _config.backend == BackendMode.rest;
    final existingIndex = products.indexWhere((p) => p.id == item.id);
    if (existingIndex >= 0) {
      products[existingIndex] = item;
    } else {
      products.add(item);
    }

    final localEntity = _toEntity(item);
    final localId = localEntity.id;
    localEntity
      ..syncStatus = isRest ? ProductSyncStatusEntity.pending : ProductSyncStatusEntity.synced
      ..syncError = '';
    await repo.upsertLocal(localEntity);
    _updateItemSync(item.id, ProductSyncStatus.pending);

    int savedId = localId;
    if (isRest) {
      try {
        final saved = await _rest.upsert(localEntity);
        await repo.markSyncedFromServer(localId: localId, server: saved);
        savedId = saved.id;
        _replaceItemId(oldId: item.id, newId: savedId.toString(), image: saved.image);
        _updateItemSync(savedId.toString(), ProductSyncStatus.synced);
      } on DioException catch (e) {
        final hasServerResponse = e.response != null;
        if (hasServerResponse) {
          await repo.markFailed(localId, e.message ?? 'Server error');
          _updateItemSync(item.id, ProductSyncStatus.failed, error: e.message ?? 'Server error');
          Get.snackbar('Gagal', 'Produk gagal disimpan: ${e.message ?? 'Server error'}');
          return;
        }

        final payload = _payloadFromEntity(localEntity);
        await _outbox.upsertPending(
          localProductId: localId,
          action: ProductOutboxActionEntity.upsert,
          payload: payload,
        );
        await repo.markPending(localId);
        _updateItemSync(item.id, ProductSyncStatus.pending);

        if (imageBytes != null) {
          await _enqueueProductImageUpload(
            localProductId: localId,
            bytes: imageBytes,
            filename: imageFilename ?? 'product.jpg',
            mimeType: imageMimeType ?? 'image/jpeg',
          );
        }
        Get.snackbar('Offline', 'Produk disimpan dan akan disinkronkan otomatis.');
      } catch (e) {
        await repo.markFailed(localId, e.toString());
        _updateItemSync(item.id, ProductSyncStatus.failed, error: e.toString());
        Get.snackbar('Gagal', 'Produk gagal disimpan: $e');
        return;
      }
    } else {
      savedId = await repo.upsert(localEntity);
    }

    if (isRest && imageBytes != null && savedId > 0) {
      try {
        final image = await _rest.uploadImage(
          productId: savedId,
          bytes: imageBytes,
          filename: imageFilename ?? 'product.jpg',
          mimeType: imageMimeType ?? 'image/jpeg',
        );
        if (image != null && image.isNotEmpty) {
          final updated = ProductEntity()
            ..id = savedId
            ..name = localEntity.name
            ..category = localEntity.category
            ..price = localEntity.price
            ..image = image
            ..trackStock = localEntity.trackStock
            ..stock = localEntity.stock
            ..minStock = localEntity.minStock;
          await repo.upsert(updated);
          final idx = products.indexWhere(
            (p) => p.id == savedId.toString() || p.id == item.id,
          );
          if (idx >= 0) {
            final current = products[idx];
            products[idx] = ProductItem(
              id: savedId.toString(),
              name: current.name,
              category: current.category,
              price: current.price,
              image: image,
              trackStock: current.trackStock,
              stock: current.stock,
              minStock: current.minStock,
            );
          }
        }
      } on DioException catch (e) {
        if (e.response != null) return;
        await _enqueueProductImageUpload(
          localProductId: savedId,
          bytes: imageBytes,
          filename: imageFilename ?? 'product.jpg',
          mimeType: imageMimeType ?? 'image/jpeg',
        );
        Get.snackbar('Offline', 'Foto produk akan diupload saat online.');
      } catch (_) {}
    }

    if (Get.isRegistered<CashierController>()) {
      await Get.find<CashierController>().refreshAll();
    }

    // If the backend assigned a new numeric ID, update the in-memory list entry.
    if (isRest && savedId > 0) {
      final previousId = item.id;
      final newId = savedId.toString();
      if (previousId != newId) {
        final idx = products.indexWhere((p) => p.id == previousId);
        if (idx >= 0) {
          final current = products[idx];
          products[idx] = ProductItem(
            id: newId,
            name: current.name,
            category: current.category,
            price: current.price,
            image: current.image,
            trackStock: current.trackStock,
            stock: current.stock,
            minStock: current.minStock,
          );
        }
      }
    }

    final idInt = savedId > 0 ? savedId : localId;
    if (!isRest) {
      if (item.trackStock) {
        final persisted = await repo.getById(idInt);
        if (persisted != null) {
          final stockEntity = _toStockEntity(persisted);
          await _stockRepo.upsert(stockEntity);
        }
      } else {
        try {
          await _stockRepo.delete(idInt);
        } catch (_) {}
      }
    }
    if (Get.isRegistered<StockController>()) {
      await Get.find<StockController>().refreshRemote();
    }
    await _loadCategories();
    logs.add(
      title: existingIndex >= 0 ? 'Ubah produk' : 'Tambah produk',
      message: '${item.name} disimpan dengan harga Rp${item.price}',
      actor: 'Manager',
    );
  }

  Future<void> deleteProduct(ProductItem item) async {
    final parsed = int.tryParse(item.id);
    final idInt = parsed ?? -item.id.hashCode.abs();
    if (_config.backend == BackendMode.rest) {
      final existing = await repo.getById(idInt);
      if (existing != null && existing.syncStatus == ProductSyncStatusEntity.pending && idInt < 0) {
        products.removeWhere((p) => p.id == item.id);
        await _outbox.cancelForLocalId(idInt);
        await repo.delete(idInt);
      } else {
        try {
          await _rest.delete(idInt);
          products.removeWhere((p) => p.id == item.id);
          await repo.delete(idInt);
        } on DioException catch (e) {
          if (e.response != null) {
            Get.snackbar('Gagal', 'Gagal menghapus produk: ${e.message ?? 'Server error'}');
            return;
          }
          await repo.markDeletedPending(idInt);
          await _outbox.upsertPending(
            localProductId: idInt,
            action: ProductOutboxActionEntity.delete,
            payload: {'id': idInt},
          );
          products.removeWhere((p) => p.id == item.id);
          Get.snackbar('Offline', 'Hapus produk disimpan dan akan disinkronkan otomatis.');
        } catch (e) {
          Get.snackbar('Gagal', 'Gagal menghapus produk: $e');
          return;
        }
      }
    } else {
      products.removeWhere((p) => p.id == item.id);
      await repo.delete(idInt);
    }
    try {
      await _stockRepo.delete(idInt);
    } catch (_) {}
    if (Get.isRegistered<StockController>()) {
      await Get.find<StockController>().refreshRemote();
    }
    if (Get.isRegistered<CashierController>()) {
      await Get.find<CashierController>().refreshAll();
    }
    logs.add(
      title: 'Hapus produk',
      message: '${item.name} dihapus',
      actor: 'Manager',
    );
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
    syncStatus: switch (e.syncStatus) {
      ProductSyncStatusEntity.pending => ProductSyncStatus.pending,
      ProductSyncStatusEntity.failed => ProductSyncStatus.failed,
      ProductSyncStatusEntity.synced => ProductSyncStatus.synced,
    },
    syncError: e.syncError,
  );

  ProductEntity _toEntity(ProductItem item) {
    final entity = ProductEntity()
      ..name = item.name
      ..category = item.category
      ..price = item.price
      ..image = item.image
      ..trackStock = item.trackStock
      ..stock = item.stock
      ..minStock = item.minStock
      ..syncStatus = switch (item.syncStatus) {
        ProductSyncStatus.pending => ProductSyncStatusEntity.pending,
        ProductSyncStatus.failed => ProductSyncStatusEntity.failed,
        ProductSyncStatus.synced => ProductSyncStatusEntity.synced,
      }
      ..syncError = item.syncError;
    final parsed = int.tryParse(item.id);
    entity.id = parsed ?? -item.id.hashCode.abs();
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
      if (_config.backend == BackendMode.rest && p.syncStatus != ProductSyncStatusEntity.synced) {
        continue;
      }
      if (!p.trackStock) {
        try {
          await _stockRepo.delete(id);
        } catch (_) {}
        continue;
      }
      trackedIds.add(id);
      await _stockRepo.upsert(_toStockEntity(p));
    }
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

  Map<String, dynamic> _payloadFromEntity(ProductEntity product) => {
    'name': product.name,
    'category': product.category,
    'price': product.price,
    'image': product.image,
    'trackStock': product.trackStock,
    'stock': product.stock,
    'minStock': product.minStock,
  };

  void _replaceItemId({required String oldId, required String newId, String? image}) {
    final idx = products.indexWhere((p) => p.id == oldId);
    if (idx < 0) return;
    final current = products[idx];
    products[idx] = ProductItem(
      id: newId,
      name: current.name,
      category: current.category,
      price: current.price,
      image: image ?? current.image,
      trackStock: current.trackStock,
      stock: current.stock,
      minStock: current.minStock,
      syncStatus: current.syncStatus,
      syncError: current.syncError,
    );
  }

  void _updateItemSync(String id, ProductSyncStatus status, {String? error}) {
    final idx = products.indexWhere((p) => p.id == id);
    if (idx < 0) return;
    products[idx].syncStatus = status;
    products[idx].syncError = error ?? (status == ProductSyncStatus.failed ? products[idx].syncError : '');
    products.refresh();
  }

  Future<void> _enqueueProductImageUpload({
    required int localProductId,
    required Uint8List bytes,
    required String filename,
    required String mimeType,
  }) async {
    final dir = await getApplicationSupportDirectory();
    final folder =
        '${dir.path}${Platform.pathSeparator}outbox_uploads${Platform.pathSeparator}product_images${Platform.pathSeparator}$localProductId';
    await Directory(folder).create(recursive: true);
    final safeName = filename.trim().isEmpty ? 'product.jpg' : filename.trim();
    final ts = DateTime.now().millisecondsSinceEpoch;
    final ext = safeName.toLowerCase().endsWith('.png') ? 'png' : 'jpg';
    final filePath = '$folder${Platform.pathSeparator}$ts.$ext';
    await File(filePath).writeAsBytes(bytes, flush: true);

    await _imageOutbox.enqueue(
      localProductId: localProductId,
      filePath: filePath,
      filename: safeName,
      mimeType: mimeType,
    );
  }
}
