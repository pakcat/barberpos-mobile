import 'dart:async';

import 'package:get/get.dart';

import '../../../../core/services/sync_service.dart';
import '../../../../core/services/activity_log_service.dart';
import '../../../../core/database/entities/activity_log_entity.dart';
import '../../../cashier/data/repositories/order_outbox_repository.dart';
import '../../../product/data/repositories/product_outbox_repository.dart';
import '../../../product/data/repositories/product_image_outbox_repository.dart';
import '../../../settings/data/repositories/qris_outbox_repository.dart';
import '../../../stock/data/repositories/stock_repository.dart';

enum SyncItemKind {
  order,
  product,
  productImage,
  qris,
  stockAdjustment,
  activityLog,
}

class SyncQueueItem {
  SyncQueueItem({
    required this.kind,
    required this.id,
    required this.title,
    required this.createdAt,
    required this.attempts,
    required this.nextAttemptAt,
    required this.lastError,
    this.subtitle,
  });

  final SyncItemKind kind;
  final int id;
  final String title;
  final String? subtitle;
  final DateTime createdAt;
  final int attempts;
  final DateTime? nextAttemptAt;
  final String? lastError;

  bool get failed => (lastError ?? '').trim().isNotEmpty;
}

class SyncController extends GetxController {
  SyncController({
    SyncService? syncService,
    ActivityLogService? logs,
    OrderOutboxRepository? orders,
    ProductOutboxRepository? products,
    ProductImageOutboxRepository? productImages,
    QrisOutboxRepository? qris,
    StockRepository? stocks,
  }) : _sync = syncService ?? Get.find<SyncService>(),
       _logs = logs ?? Get.find<ActivityLogService>(),
       _orders = orders ?? Get.find<OrderOutboxRepository>(),
       _products = products ?? Get.find<ProductOutboxRepository>(),
       _productImages = productImages ?? Get.find<ProductImageOutboxRepository>(),
       _qris = qris ?? Get.find<QrisOutboxRepository>(),
       _stocks = stocks ?? Get.find<StockRepository>();

  final SyncService _sync;
  final ActivityLogService _logs;
  final OrderOutboxRepository _orders;
  final ProductOutboxRepository _products;
  final ProductImageOutboxRepository _productImages;
  final QrisOutboxRepository _qris;
  final StockRepository _stocks;

  final RxList<SyncQueueItem> mainItems = <SyncQueueItem>[].obs;
  final RxList<SyncQueueItem> logItems = <SyncQueueItem>[].obs;
  final loading = false.obs;
  final syncing = false.obs;

  int get totalPending => mainItems.length + logItems.length;
  int get totalFailed => totalMainFailed + totalLogFailed;

  int get totalMainPending => mainItems.length;
  int get totalMainFailed => mainItems.where((e) => e.failed).length;

  int get totalLogPending => logItems.length;
  int get totalLogFailed => logItems.where((e) => e.failed).length;

  @override
  void onInit() {
    super.onInit();
    unawaited(refresh());
  }

  @override
  Future<void> refresh() async {
    loading.value = true;
    try {
      final mainNext = <SyncQueueItem>[];
      final logNext = <SyncQueueItem>[];

      final orders = await _orders.allUnsynced();
      for (final o in orders) {
        mainNext.add(
          SyncQueueItem(
            kind: SyncItemKind.order,
            id: o.id,
            title: o.pendingCode,
            subtitle: 'Order cash (outbox)',
            createdAt: o.createdAt,
            attempts: o.attempts,
            nextAttemptAt: o.nextAttemptAt,
            lastError: o.lastError,
          ),
        );
      }

      final productOps = await _products.allUnsynced();
      for (final p in productOps) {
        mainNext.add(
          SyncQueueItem(
            kind: SyncItemKind.product,
            id: p.id,
            title: 'Produk ${p.action.name}',
            subtitle: 'LocalId: ${p.localProductId}',
            createdAt: p.createdAt,
            attempts: p.attempts,
            nextAttemptAt: p.nextAttemptAt,
            lastError: p.lastError,
          ),
        );
      }

      final productImages = await _productImages.allUnsynced();
      for (final img in productImages) {
        mainNext.add(
          SyncQueueItem(
            kind: SyncItemKind.productImage,
            id: img.id,
            title: 'Foto produk',
            subtitle: 'LocalId: ${img.localProductId}',
            createdAt: img.createdAt,
            attempts: img.attempts,
            nextAttemptAt: img.nextAttemptAt,
            lastError: img.lastError,
          ),
        );
      }

      final qris = await _qris.allUnsynced();
      for (final q in qris) {
        mainNext.add(
          SyncQueueItem(
            kind: SyncItemKind.qris,
            id: q.id,
            title: 'QRIS ${q.action.name}',
            subtitle: q.filename.isNotEmpty ? q.filename : null,
            createdAt: q.createdAt,
            attempts: q.attempts,
            nextAttemptAt: q.nextAttemptAt,
            lastError: q.lastError,
          ),
        );
      }

      final stockAdj = await _stocks.getAllUnsyncedAdjustments();
      for (final s in stockAdj) {
        mainNext.add(
          SyncQueueItem(
            kind: SyncItemKind.stockAdjustment,
            id: s.id,
            title: 'Stok ${s.type} (${s.change})',
            subtitle: 'StockId: ${s.stockId}',
            createdAt: s.createdAt,
            attempts: s.attempts,
            nextAttemptAt: s.nextAttemptAt,
            lastError: s.lastError,
          ),
        );
      }

      final logs = await _logs.allUnsyncedEntities();
      for (final ActivityLogEntity l in logs) {
        logNext.add(
          SyncQueueItem(
            kind: SyncItemKind.activityLog,
            id: l.id,
            title: l.title,
            subtitle: l.actor,
            createdAt: l.timestamp,
            attempts: l.attempts,
            nextAttemptAt: l.nextAttemptAt,
            lastError: l.lastError,
          ),
        );
      }

      mainNext.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      logNext.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      mainItems.assignAll(mainNext);
      logItems.assignAll(logNext);
    } finally {
      loading.value = false;
    }
  }

  Future<void> syncNow() async {
    if (syncing.value) return;
    syncing.value = true;
    try {
      await _sync.syncAll();
      await refresh();
    } finally {
      syncing.value = false;
    }
  }

  Future<void> retry(SyncQueueItem item) async {
    switch (item.kind) {
      case SyncItemKind.order:
        await _orders.resetRetry(id: item.id);
        break;
      case SyncItemKind.product:
        await _products.resetRetry(id: item.id);
        break;
      case SyncItemKind.productImage:
        await _productImages.resetRetry(id: item.id);
        break;
      case SyncItemKind.qris:
        await _qris.resetRetry(id: item.id);
        break;
      case SyncItemKind.stockAdjustment:
        await _stocks.resetAdjustmentRetry(item.id);
        break;
      case SyncItemKind.activityLog:
        await _logs.resetRetry(item.id);
        break;
    }
    await syncNow();
  }

  Future<void> remove(SyncQueueItem item) async {
    switch (item.kind) {
      case SyncItemKind.order:
        // Delete specific row by ID.
        await _orders.deleteById(item.id);
        break;
      case SyncItemKind.product:
        await _products.deleteById(item.id);
        break;
      case SyncItemKind.productImage:
        await _productImages.deleteById(item.id);
        break;
      case SyncItemKind.qris:
        await _qris.deleteById(item.id);
        break;
      case SyncItemKind.stockAdjustment:
        await _stocks.deleteAdjustment(item.id);
        break;
      case SyncItemKind.activityLog:
        await _logs.deleteById(item.id);
        break;
    }
    await refresh();
  }
}
