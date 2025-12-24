import 'dart:async';

import 'package:get/get.dart';

import '../services/activity_log_service.dart';
import '../../modules/cashier/data/repositories/order_outbox_repository.dart';
import '../../modules/product/data/repositories/product_outbox_repository.dart';
import '../../modules/product/data/repositories/product_image_outbox_repository.dart';
import '../../modules/settings/data/repositories/qris_outbox_repository.dart';
import '../../modules/stock/data/repositories/stock_repository.dart';

class SyncQueueService extends GetxService {
  SyncQueueService({Duration interval = const Duration(seconds: 10)}) : _interval = interval;

  final Duration _interval;
  Timer? _timer;

  final pendingCount = 0.obs;
  final failedCount = 0.obs;

  final pendingPrimaryCount = 0.obs;
  final failedPrimaryCount = 0.obs;
  final pendingLogsCount = 0.obs;
  final failedLogsCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _timer = Timer.periodic(_interval, (_) => unawaited(refresh()));
    unawaited(refresh());
  }

  Future<void> refresh() async {
    try {
      final orders = Get.isRegistered<OrderOutboxRepository>() ? Get.find<OrderOutboxRepository>() : null;
      final products = Get.isRegistered<ProductOutboxRepository>() ? Get.find<ProductOutboxRepository>() : null;
      final productImages =
          Get.isRegistered<ProductImageOutboxRepository>() ? Get.find<ProductImageOutboxRepository>() : null;
      final qris = Get.isRegistered<QrisOutboxRepository>() ? Get.find<QrisOutboxRepository>() : null;
      final stocks = Get.isRegistered<StockRepository>() ? Get.find<StockRepository>() : null;
      final logs = Get.isRegistered<ActivityLogService>() ? Get.find<ActivityLogService>() : null;

      var pendingPrimary = 0;
      var failedPrimary = 0;
      var pendingLogs = 0;
      var failedLogs = 0;

      if (orders != null) {
        final rows = await orders.allUnsynced();
        pendingPrimary += rows.length;
        failedPrimary += rows.where((e) => (e.lastError ?? '').trim().isNotEmpty).length;
      }
      if (products != null) {
        final rows = await products.allUnsynced();
        pendingPrimary += rows.length;
        failedPrimary += rows.where((e) => (e.lastError ?? '').trim().isNotEmpty).length;
      }
      if (productImages != null) {
        final rows = await productImages.allUnsynced();
        pendingPrimary += rows.length;
        failedPrimary += rows.where((e) => (e.lastError ?? '').trim().isNotEmpty).length;
      }
      if (qris != null) {
        final rows = await qris.allUnsynced();
        pendingPrimary += rows.length;
        failedPrimary += rows.where((e) => (e.lastError ?? '').trim().isNotEmpty).length;
      }
      if (stocks != null) {
        final rows = await stocks.getAllUnsyncedAdjustments();
        pendingPrimary += rows.length;
        failedPrimary += rows.where((e) => (e.lastError ?? '').trim().isNotEmpty).length;
      }
      if (logs != null) {
        final rows = await logs.allUnsyncedEntities();
        pendingLogs += rows.length;
        failedLogs += rows.where((e) => (e.lastError ?? '').trim().isNotEmpty).length;
      }

      pendingPrimaryCount.value = pendingPrimary;
      failedPrimaryCount.value = failedPrimary;
      pendingLogsCount.value = pendingLogs;
      failedLogsCount.value = failedLogs;

      pendingCount.value = pendingPrimary + pendingLogs;
      failedCount.value = failedPrimary + failedLogs;
    } catch (_) {
      // Keep previous counts.
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
