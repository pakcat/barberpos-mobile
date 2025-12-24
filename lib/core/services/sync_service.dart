import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../network/network_service.dart';
import 'activity_log_service.dart';
import '../../modules/stock/data/repositories/stock_repository.dart';
import '../../modules/cashier/data/repositories/order_outbox_repository.dart';
import '../../modules/transactions/data/repositories/transaction_repository.dart';
import '../../modules/reports/data/repositories/reports_repository.dart';

class SyncService extends GetxService {
  SyncService({Duration interval = const Duration(minutes: 5)}) : _interval = interval;

  final Duration _interval;
  Timer? _timer;
  late final Future<void> _ready;
  late final ActivityLogService _logs;
  late final StockRepository _stocks;
  late final OrderOutboxRepository _orders;
  late final TransactionRepository _txRepo;
  late final ReportsRepository _reports;
  NetworkService? _network;

  @override
  void onInit() {
    super.onInit();
    _ready = _init();
    unawaited(_ready.then((_) => syncAll()));
  }

  Future<void> _init() async {
    _logs = Get.find<ActivityLogService>();
    _stocks = Get.find<StockRepository>();
    _orders = Get.find<OrderOutboxRepository>();
    _txRepo = Get.find<TransactionRepository>();
    _reports = Get.find<ReportsRepository>();
    _network = Get.isRegistered<NetworkService>() ? Get.find<NetworkService>() : null;
    _timer = Timer.periodic(_interval, (_) => unawaited(syncAll()));
  }

  Future<void> syncAll() async {
    await syncActivityLogs();
    await syncStockAdjustments();
    await syncOrders();
  }

  Future<void> syncActivityLogs() async {
    if (_network == null) return;
    await _ready;
    final pending = await _logs.getUnsynced();
    if (pending.isEmpty) return;

    final syncedIds = <int>[];
    for (final log in pending) {
      if (log.id == null) continue;
      try {
        await _uploadActivityLog(log);
        syncedIds.add(log.id!);
      } on DioException catch (_) {
        // Keep pending, retry next cycle.
        break;
      } catch (_) {
        break;
      }
    }

    if (syncedIds.isNotEmpty) {
      await _logs.markAsSynced(syncedIds);
    }
  }

  Future<void> _uploadActivityLog(ActivityLog log) async {
    // Placeholder: integrate with backend endpoint once available.
    await _network!.dio.post('/logs', data: {
      'title': log.title,
      'message': log.message,
      'actor': log.actor,
      'type': log.type.name,
      'timestamp': log.timestamp.toIso8601String(),
    });
  }

  Future<void> syncStockAdjustments() async {
    if (_network == null) return;
    await _ready;
    if (_stocks.restRemote == null) return;
    final pending = await _stocks.getPendingAdjustments(limit: 50);
    if (pending.isEmpty) return;

    final synced = <int>[];
    for (final adj in pending) {
      try {
        await _stocks.restRemote!.adjust(
          stockId: adj.stockId,
          change: adj.change,
          type: adj.type,
          note: adj.note.isEmpty ? null : adj.note,
          productId: adj.productId,
        );
        synced.add(adj.id);
      } on DioException catch (_) {
        break;
      } catch (_) {
        break;
      }
    }

    if (synced.isNotEmpty) {
      await _stocks.markAdjustmentsSynced(synced);
      try {
        final latest = await _stocks.restRemote!.fetchAll();
        await _stocks.replaceAll(latest);
      } catch (_) {}
    }
  }

  Future<void> syncOrders() async {
    if (_network == null) return;
    await _ready;
    final pending = await _orders.pending(limit: 20);
    if (pending.isEmpty) return;

    for (final item in pending) {
      try {
        final payload = jsonDecode(item.payloadJson) as Map<String, dynamic>;
        final res = await _network!.dio.post<Map<String, dynamic>>('/orders', data: payload);
        final data = res.data ?? <String, dynamic>{};
        final serverCode = data['code']?.toString() ?? '';
        if (serverCode.isEmpty) {
          await _orders.markFailed(id: item.id, message: 'Empty server code');
          break;
        }

        await _txRepo.updateCode(oldCode: item.pendingCode, newCode: serverCode);
        await _reports.updateTransactionCode(oldCode: item.pendingCode, newCode: serverCode);
        await _orders.markSynced(id: item.id, serverCode: serverCode);
      } on DioException catch (_) {
        break;
      } catch (e) {
        await _orders.markFailed(id: item.id, message: e.toString());
        break;
      }
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
