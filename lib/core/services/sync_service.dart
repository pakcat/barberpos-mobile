import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../config/app_config.dart';
import '../network/network_service.dart';
import 'activity_log_firestore_data_source.dart';
import 'activity_log_service.dart';

class SyncService extends GetxService {
  SyncService({Duration interval = const Duration(minutes: 5)}) : _interval = interval;

  final Duration _interval;
  Timer? _timer;
  late final Future<void> _ready;
  late final ActivityLogService _logs;
  NetworkService? _network;
  ActivityLogFirestoreDataSource? _logsRemote;
  late final AppConfig _config;

  @override
  void onInit() {
    super.onInit();
    _ready = _init();
  }

  Future<void> _init() async {
    _logs = Get.find<ActivityLogService>();
    _config = Get.find<AppConfig>();
    _network = Get.isRegistered<NetworkService>() ? Get.find<NetworkService>() : null;
    if (_config.backend == BackendMode.firebase) {
      _logsRemote = ActivityLogFirestoreDataSource(FirebaseFirestore.instance);
    }
    _timer = Timer.periodic(_interval, (_) => syncAll());
  }

  Future<void> syncAll() async {
    await syncActivityLogs();
  }

  Future<void> syncActivityLogs() async {
    if (_network == null && _logsRemote == null) return;
    await _ready;
    final pending = await _logs.getUnsynced();
    if (pending.isEmpty) return;

    final syncedIds = <int>[];
    for (final log in pending) {
      if (log.id == null) continue;
      try {
        if (_logsRemote != null) {
          await _logsRemote!.add(log);
        } else {
          await _uploadActivityLog(log);
        }
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

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
