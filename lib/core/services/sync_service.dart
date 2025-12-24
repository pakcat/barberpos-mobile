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
import '../../modules/product/data/repositories/product_repository.dart';
import '../../modules/product/data/repositories/product_outbox_repository.dart';
import '../../modules/product/data/entities/product_outbox_entity.dart';
import '../../modules/product/data/entities/product_entity.dart';
import '../../modules/product/data/repositories/product_image_outbox_repository.dart';
import '../../modules/settings/data/repositories/qris_outbox_repository.dart';
import '../../modules/settings/data/datasources/settings_remote_data_source.dart';
import '../../modules/settings/data/entities/qris_outbox_entity.dart';
import '../../modules/staff/data/repositories/attendance_outbox_repository.dart';
import '../../modules/staff/data/entities/attendance_outbox_entity.dart';
import 'auth_service.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

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
  late final ProductOutboxRepository _productOutbox;
  late final ProductRepository _products;
  late final ProductImageOutboxRepository _productImages;
  late final QrisOutboxRepository _qrisOutbox;
  late final AttendanceOutboxRepository _attendanceOutbox;
  AuthService? _auth;
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
    _productOutbox = Get.find<ProductOutboxRepository>();
    _products = Get.find<ProductRepository>();
    _productImages = Get.find<ProductImageOutboxRepository>();
    _qrisOutbox = Get.find<QrisOutboxRepository>();
    _attendanceOutbox = Get.find<AttendanceOutboxRepository>();
    _network = Get.isRegistered<NetworkService>() ? Get.find<NetworkService>() : null;
    _auth = Get.isRegistered<AuthService>() ? Get.find<AuthService>() : null;
    _timer = Timer.periodic(_interval, (_) => unawaited(syncAll()));
  }

  Future<void> syncAll() async {
    await syncActivityLogs();
    await syncOrders();
    await syncAttendance();
    if (_auth?.isManager == true) {
      await syncStockAdjustments();
      await syncProducts();
      await syncProductImages();
      await syncQris();
    }
    await cleanupOutbox();
  }

  bool _isPermanentHttpFailure(int? statusCode) {
    if (statusCode == null) return false;
    if (statusCode == 429) return false;
    if (statusCode >= 500) return false;
    // Treat most 4xx as permanent (bad payload / conflict / unauthorized) until manual intervention.
    return statusCode >= 400 && statusCode < 500;
  }

  Future<void> syncActivityLogs() async {
    if (_network == null) return;
    await _ready;
    final pending = await _logs.getUnsynced();
    if (pending.isEmpty) return;

    final syncedIds = <int>[];
    for (final log in pending) {
      if (log.id == null) continue;
      await _logs.recordAttempt(id: log.id!);
      try {
        await _uploadActivityLog(log);
        syncedIds.add(log.id!);
      } on DioException catch (e) {
        final status = e.response?.statusCode;
        if (_isPermanentHttpFailure(status)) {
          await _logs.markPermanentFailed(id: log.id!, message: 'HTTP $status: ${e.message ?? 'error'}');
          continue;
        }
        await _logs.markFailed(id: log.id!, message: e.message ?? 'Network error');
        break;
      } catch (_) {
        await _logs.markFailed(id: log.id!, message: 'Unknown error');
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
        await _stocks.recordAdjustmentAttempt(adj.id);
        await _stocks.restRemote!.adjust(
          stockId: adj.stockId,
          change: adj.change,
          type: adj.type,
          note: adj.note.isEmpty ? null : adj.note,
          productId: adj.productId,
        );
        synced.add(adj.id);
      } on DioException catch (e) {
        final status = e.response?.statusCode;
        if (_isPermanentHttpFailure(status)) {
          await _stocks.markAdjustmentPermanentFailed(
            id: adj.id,
            message: 'HTTP $status: ${e.message ?? 'error'}',
          );
          continue;
        }
        await _stocks.markAdjustmentFailed(id: adj.id, message: e.message ?? 'Network error');
        break;
      } catch (_) {
        await _stocks.markAdjustmentFailed(id: adj.id, message: 'Unknown error');
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
        await _orders.recordAttempt(id: item.id);
        final payload = jsonDecode(item.payloadJson) as Map<String, dynamic>;
        final res = await _network!.dio.post<Map<String, dynamic>>(
          '/orders',
          data: payload,
          options: Options(headers: {'X-Idempotency-Key': item.clientRef}),
        );
        final data = res.data ?? <String, dynamic>{};
        final serverCode = data['code']?.toString() ?? '';
        if (serverCode.isEmpty) {
          await _orders.markFailed(id: item.id, message: 'Empty server code');
          continue;
        }

        await _txRepo.markSyncedPending(pendingCode: item.pendingCode, serverCode: serverCode);
        await _reports.updateTransactionCode(oldCode: item.pendingCode, newCode: serverCode);
        await _orders.markSynced(id: item.id, serverCode: serverCode);
      } on DioException catch (e) {
        final status = e.response?.statusCode;
        if (_isPermanentHttpFailure(status)) {
          await _orders.markPermanentFailed(id: item.id, message: 'HTTP $status: ${e.message ?? 'error'}');
          continue;
        }
        await _orders.markFailed(id: item.id, message: e.message ?? 'Network error');
        if (e.response == null) break;
        continue;
      } catch (e) {
        await _orders.markFailed(id: item.id, message: e.toString());
        continue;
      }
    }
  }

  Future<void> syncAttendance() async {
    if (_network == null) return;
    await _ready;
    final pending = await _attendanceOutbox.pending(limit: 20);
    if (pending.isEmpty) return;

    for (final item in pending) {
      try {
        await _attendanceOutbox.recordAttempt(id: item.id);
        final endpoint = item.action == AttendanceOutboxActionEntity.checkIn
            ? '/attendance/checkin'
            : '/attendance/checkout';
        await _network!.dio.post(
          endpoint,
          data: {
            'employeeId': item.employeeId,
            'employeeName': item.employeeName,
            'date':
                '${item.date.year}-${item.date.month.toString().padLeft(2, '0')}-${item.date.day.toString().padLeft(2, '0')}',
            'source': item.source,
          },
        );
        await _attendanceOutbox.markSynced(id: item.id);
      } on DioException catch (e) {
        final status = e.response?.statusCode;
        if (_isPermanentHttpFailure(status)) {
          await _attendanceOutbox.markPermanentFailed(
            id: item.id,
            message: 'HTTP $status: ${e.message ?? 'error'}',
          );
          continue;
        }
        await _attendanceOutbox.markFailed(id: item.id, message: e.message ?? 'Network error');
        if (e.response == null) break;
        continue;
      } catch (e) {
        await _attendanceOutbox.markFailed(id: item.id, message: e.toString());
        continue;
      }
    }
  }

  Future<void> syncProducts() async {
    if (_network == null) return;
    await _ready;
    final remote = _products.restRemote;
    if (remote == null) return;

    final pending = await _productOutbox.pending(limit: 20);
    if (pending.isEmpty) return;

    for (final item in pending) {
      try {
        await _productOutbox.recordAttempt(id: item.id);
        final payload = jsonDecode(item.payloadJson) as Map<String, dynamic>;
        switch (item.action) {
          case ProductOutboxActionEntity.upsert:
            final local = await _products.getById(item.localProductId);
            final entity = local ?? _productFromPayload(item.localProductId, payload);
            final saved = await remote.upsert(entity);
            await _products.markSyncedFromServer(localId: item.localProductId, server: saved);
            await _productOutbox.markSynced(id: item.id, serverId: saved.id.toString());
            break;
          case ProductOutboxActionEntity.delete:
            final id = int.tryParse(payload['id']?.toString() ?? '') ?? item.localProductId;
            await remote.delete(id);
            await _products.delete(item.localProductId);
            await _productOutbox.markSynced(id: item.id, serverId: id.toString());
            break;
        }
      } on DioException catch (e) {
        final status = e.response?.statusCode;
        if (_isPermanentHttpFailure(status)) {
          await _productOutbox.markPermanentFailed(id: item.id, message: 'HTTP $status: ${e.message ?? 'error'}');
          continue;
        }
        await _productOutbox.markFailed(id: item.id, message: e.message ?? 'Network error');
        if (e.response == null) break;
        continue;
      } catch (e) {
        await _productOutbox.markFailed(id: item.id, message: e.toString());
        continue;
      }
    }
  }

  Future<void> syncProductImages() async {
    if (_network == null) return;
    await _ready;
    final remote = _products.restRemote;
    if (remote == null) return;

    final pending = await _productImages.pending(limit: 20);
    if (pending.isEmpty) return;

    for (final item in pending) {
      try {
        await _productImages.recordAttempt(id: item.id);
        final p = await _products.getById(item.localProductId);
        if (p == null || p.deleted) {
          await _productImages.markFailed(id: item.id, message: 'Product missing/deleted');
          _tryDeleteFile(item.filePath);
          continue;
        }
        if (p.syncStatus != ProductSyncStatusEntity.synced || p.id <= 0) {
          // Wait until product is synced (has server ID).
          continue;
        }

        final file = File(item.filePath);
        if (!await file.exists()) {
          await _productImages.markFailed(id: item.id, message: 'File missing');
          continue;
        }
        final bytes = await file.readAsBytes();
        final image = await remote.uploadImage(
          productId: p.id,
          bytes: bytes,
          filename: item.filename,
          mimeType: item.mimeType,
        );
        if (image != null && image.isNotEmpty) {
          p.image = image;
          await _products.upsertLocal(p);
        }
        await _productImages.markSynced(id: item.id);
        _tryDeleteFile(item.filePath);
      } on DioException catch (e) {
        final status = e.response?.statusCode;
        if (_isPermanentHttpFailure(status)) {
          await _productImages.markPermanentFailed(id: item.id, message: 'HTTP $status: ${e.message ?? 'error'}');
          continue;
        }
        await _productImages.markFailed(id: item.id, message: e.message ?? 'Network error');
        if (e.response == null) break;
        continue;
      } catch (e) {
        await _productImages.markFailed(id: item.id, message: e.toString());
        continue;
      }
    }
  }

  Future<void> syncQris() async {
    if (_network == null) return;
    await _ready;
    final remote = SettingsRemoteDataSource(_network!.dio);

    final pending = await _qrisOutbox.pending(limit: 10);
    if (pending.isEmpty) return;

    for (final item in pending) {
      try {
        await _qrisOutbox.recordAttempt(id: item.id);
        switch (item.action) {
          case QrisOutboxActionEntity.upload:
            final file = File(item.filePath);
            if (!await file.exists()) {
              await _qrisOutbox.markFailed(id: item.id, message: 'File missing');
              continue;
            }
            final bytes = await file.readAsBytes();
            await remote.saveQrisImage(bytes: bytes, filename: item.filename, mimeType: item.mimeType);
            await _qrisOutbox.markSynced(id: item.id);
            _tryDeleteFile(item.filePath);
            // Also refresh local cache if possible.
            try {
              final cache = await _qrisCachePath();
              await File(cache).writeAsBytes(bytes, flush: true);
            } catch (_) {}
            break;
          case QrisOutboxActionEntity.delete:
            await remote.clearQrisImage();
            await _qrisOutbox.markSynced(id: item.id);
            try {
              final cache = await _qrisCachePath();
              _tryDeleteFile(cache);
            } catch (_) {}
            break;
        }
      } on DioException catch (e) {
        final status = e.response?.statusCode;
        if (_isPermanentHttpFailure(status)) {
          await _qrisOutbox.markPermanentFailed(id: item.id, message: 'HTTP $status: ${e.message ?? 'error'}');
          continue;
        }
        await _qrisOutbox.markFailed(id: item.id, message: e.message ?? 'Network error');
        if (e.response == null) break;
        continue;
      } catch (e) {
        await _qrisOutbox.markFailed(id: item.id, message: e.toString());
        continue;
      }
    }
  }

  Future<String> _qrisCachePath() async {
    final dir = await getApplicationSupportDirectory();
    final folder = '${dir.path}${Platform.pathSeparator}qris_cache';
    await Directory(folder).create(recursive: true);
    return '$folder${Platform.pathSeparator}qris.jpg';
  }

  void _tryDeleteFile(String path) {
    try {
      final f = File(path);
      if (f.existsSync()) {
        f.deleteSync();
      }
    } catch (_) {}
  }

  Future<void> cleanupOutbox() async {
    await _ready;
    try {
      // Keep synced rows for a short time for troubleshooting, then prune.
      await _orders.pruneSyncedOlderThan(age: const Duration(days: 2));
      await _productOutbox.pruneSyncedOlderThan(age: const Duration(days: 2));
      await _productImages.pruneSyncedOlderThan(age: const Duration(days: 2));
      await _qrisOutbox.pruneSyncedOlderThan(age: const Duration(days: 2));
      await _attendanceOutbox.pruneSyncedOlderThan(age: const Duration(days: 2));

      // Remove very old failed upload rows to avoid unbounded growth.
      // (Files may already be missing; we don't attempt to delete cache paths here.)
      await _productImages.pruneFailedOlderThan(age: const Duration(days: 14));
    } catch (_) {}

    await _cleanupOrphanUploadFiles();
  }

  Future<void> _cleanupOrphanUploadFiles() async {
    try {
      final dir = await getApplicationSupportDirectory();
      final root = Directory(
        '${dir.path}${Platform.pathSeparator}outbox_uploads${Platform.pathSeparator}product_images',
      );
      if (!await root.exists()) return;

      final cutoff = DateTime.now().subtract(const Duration(days: 30));
      final productDirs = root.listSync(followLinks: false).whereType<Directory>().toList();
      for (final d in productDirs) {
        // Delete old files inside.
        for (final f in d.listSync(followLinks: false)) {
          if (f is! File) continue;
          try {
            final stat = f.statSync();
            if (stat.modified.isBefore(cutoff)) {
              f.deleteSync();
            }
          } catch (_) {}
        }
        // Remove empty dir.
        try {
          final remaining = d.listSync(followLinks: false);
          if (remaining.isEmpty) {
            d.deleteSync(recursive: true);
          }
        } catch (_) {}
      }
    } catch (_) {}
  }

  ProductEntity _productFromPayload(int localId, Map<String, dynamic> payload) {
    final entity = ProductEntity()
      ..id = localId
      ..name = payload['name']?.toString() ?? ''
      ..category = payload['category']?.toString() ?? ''
      ..price = int.tryParse(payload['price']?.toString() ?? '') ?? 0
      ..image = payload['image']?.toString() ?? ''
      ..trackStock = payload['trackStock'] == true
      ..stock = int.tryParse(payload['stock']?.toString() ?? '') ?? 0
      ..minStock = int.tryParse(payload['minStock']?.toString() ?? '') ?? 0;
    return entity;
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
