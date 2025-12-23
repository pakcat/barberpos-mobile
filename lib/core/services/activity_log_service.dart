import 'package:get/get.dart';
import 'package:isar_community/isar.dart';

import '../database/entities/activity_log_entity.dart';
import '../database/local_database.dart';
import '../models/activity_log.dart';

export '../models/activity_log.dart';

class ActivityLogService extends GetxService {
  ActivityLogService({required Future<LocalDatabase> dbReady}) : _dbReady = dbReady;

  final Future<LocalDatabase> _dbReady;

  final RxList<ActivityLog> logs = <ActivityLog>[].obs;

  late final Future<void> _ready;
  late final Isar _isar;

  @override
  void onInit() {
    super.onInit();
    _ready = _init();
  }

  Future<void> _init() async {
    final db = await _dbReady;
    _isar = db.isar;
    await _loadFromDb();
    if (logs.isEmpty) {
      final bootstrapLog = ActivityLog(
        title: 'Sistem siap',
        message: 'Backoffice BarberPOS dimuat',
        actor: 'System',
      );
      logs.insert(0, bootstrapLog);
      await _persist(bootstrapLog);
    }
  }

  Future<void> _loadFromDb() async {
    final stored = await _isar.activityLogEntitys.where().sortByTimestampDesc().findAll();
    logs.assignAll(stored.map((e) => e.toModel()));
  }

  Future<void> add({
    required String title,
    required String message,
    String actor = 'System',
    ActivityLogType type = ActivityLogType.info,
  }) async {
    final log = ActivityLog(
      title: title,
      message: message,
      actor: actor,
      type: type,
      synced: false,
    );
    logs.insert(0, log);
    await _ready;
    await _persist(log);
  }

  Future<List<ActivityLog>> getUnsynced({int limit = 50}) async {
    await _ready;
    final pending = await _isar.activityLogEntitys
        .filter()
        .syncedEqualTo(false)
        .sortByTimestampDesc()
        .limit(limit)
        .findAll();
    return pending.map((e) => e.toModel()).toList();
  }

  Future<void> markAsSynced(Iterable<Id> ids) async {
    final idSet = ids.toSet();
    if (idSet.isEmpty) return;
    await _ready;
    await _isar.writeTxn(() async {
      final items = await _isar.activityLogEntitys.getAll(idSet.toList());
      final updated = items.whereType<ActivityLogEntity>().toList();
      for (final item in updated) {
        item.synced = true;
      }
      await _isar.activityLogEntitys.putAll(updated);
    });
    for (var i = 0; i < logs.length; i++) {
      final log = logs[i];
      if (log.id != null && idSet.contains(log.id)) {
        logs[i] = log.copyWith(synced: true);
      }
    }
  }

  Future<int> _persist(ActivityLog log) async {
    final id = await _isar.writeTxn<int>(() async {
      return await _isar.activityLogEntitys.put(log.toEntity());
    });
    final index = logs.indexWhere(
      (item) =>
          item.timestamp == log.timestamp &&
          item.title == log.title &&
          item.message == log.message &&
          item.actor == log.actor,
    );
    if (index != -1) {
      logs[index] = logs[index].copyWith(id: id);
    }
    return id;
  }
}

