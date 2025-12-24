import 'package:isar_community/isar.dart';

import '../../../../core/database/local_database.dart';
import '../../../../core/utils/retry_backoff.dart';
import '../entities/attendance_outbox_entity.dart';

class AttendanceOutboxRepository {
  AttendanceOutboxRepository(Future<LocalDatabase> dbReady) : _dbReady = dbReady;

  final Future<LocalDatabase> _dbReady;

  Future<Isar> get _isar async => (await _dbReady).isar;

  Future<int> enqueue({
    required AttendanceOutboxActionEntity action,
    required String employeeName,
    required DateTime date,
    int? employeeId,
    String source = 'employee',
  }) async {
    final isar = await _isar;
    final d = DateTime(date.year, date.month, date.day);
    final entity = AttendanceOutboxEntity()
      ..action = action
      ..employeeId = employeeId
      ..employeeName = employeeName
      ..date = d
      ..source = source
      ..createdAt = DateTime.now()
      ..synced = false
      ..attempts = 0
      ..lastAttemptAt = null
      ..nextAttemptAt = null;
    return isar.writeTxn(() => isar.attendanceOutboxEntitys.put(entity));
  }

  Future<List<AttendanceOutboxEntity>> pending({int limit = 20}) async {
    final isar = await _isar;
    final now = DateTime.now();
    return isar.attendanceOutboxEntitys
        .filter()
        .syncedEqualTo(false)
        .nextAttemptAtIsNull()
        .or()
        .syncedEqualTo(false)
        .nextAttemptAtLessThan(now, include: true)
        .sortByCreatedAt()
        .limit(limit)
        .findAll();
  }

  Future<List<AttendanceOutboxEntity>> allUnsynced({int limit = 200}) async {
    final isar = await _isar;
    return isar.attendanceOutboxEntitys
        .filter()
        .syncedEqualTo(false)
        .sortByCreatedAt()
        .limit(limit)
        .findAll();
  }

  Future<void> recordAttempt({required int id}) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      final entity = await isar.attendanceOutboxEntitys.get(id);
      if (entity == null) return;
      entity
        ..attempts = entity.attempts + 1
        ..lastAttemptAt = DateTime.now();
      await isar.attendanceOutboxEntitys.put(entity);
    });
  }

  Future<void> markSynced({required int id}) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      final entity = await isar.attendanceOutboxEntitys.get(id);
      if (entity == null) return;
      entity
        ..synced = true
        ..syncedAt = DateTime.now()
        ..lastError = null
        ..nextAttemptAt = null;
      await isar.attendanceOutboxEntitys.put(entity);
    });
  }

  Future<void> markFailed({required int id, required String message}) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      final entity = await isar.attendanceOutboxEntitys.get(id);
      if (entity == null) return;
      entity.lastError = message;
      entity.nextAttemptAt = DateTime.now().add(computeRetryBackoff(entity.attempts));
      await isar.attendanceOutboxEntitys.put(entity);
    });
  }

  Future<void> markPermanentFailed({required int id, required String message}) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      final entity = await isar.attendanceOutboxEntitys.get(id);
      if (entity == null) return;
      entity
        ..lastError = message
        ..nextAttemptAt = DateTime.now().add(const Duration(days: 3650));
      await isar.attendanceOutboxEntitys.put(entity);
    });
  }

  Future<void> resetRetry({required int id}) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      final entity = await isar.attendanceOutboxEntitys.get(id);
      if (entity == null) return;
      entity.nextAttemptAt = null;
      await isar.attendanceOutboxEntitys.put(entity);
    });
  }

  Future<void> deleteById(int id) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      await isar.attendanceOutboxEntitys.delete(id);
    });
  }

  Future<int> pruneSyncedOlderThan({
    required Duration age,
    int limit = 500,
  }) async {
    final isar = await _isar;
    final cutoff = DateTime.now().subtract(age);
    final rows = await isar.attendanceOutboxEntitys
        .filter()
        .syncedEqualTo(true)
        .syncedAtLessThan(cutoff, include: true)
        .limit(limit)
        .findAll();
    if (rows.isEmpty) return 0;
    final ids = rows.map((e) => e.id).toList();
    await isar.writeTxn(() async {
      await isar.attendanceOutboxEntitys.deleteAll(ids);
    });
    return ids.length;
  }
}

