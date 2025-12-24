import 'package:isar_community/isar.dart';

import '../../../../core/database/local_database.dart';
import '../../../../core/utils/retry_backoff.dart';
import '../entities/qris_outbox_entity.dart';

class QrisOutboxRepository {
  QrisOutboxRepository(Future<LocalDatabase> dbReady) : _dbReady = dbReady;

  final Future<LocalDatabase> _dbReady;

  Future<Isar> get _isar async => (await _dbReady).isar;

  Future<int> enqueueUpload({
    required String filePath,
    required String filename,
    required String mimeType,
  }) async {
    final isar = await _isar;
    final entity = QrisOutboxEntity()
      ..action = QrisOutboxActionEntity.upload
      ..filePath = filePath
      ..filename = filename
      ..mimeType = mimeType
      ..createdAt = DateTime.now()
      ..synced = false
      ..syncedAt = null
      ..lastError = null
      ..attempts = 0
      ..lastAttemptAt = null
      ..nextAttemptAt = null;
    return isar.writeTxn(() => isar.qrisOutboxEntitys.put(entity));
  }

  Future<int> enqueueDelete() async {
    final isar = await _isar;
    final entity = QrisOutboxEntity()
      ..action = QrisOutboxActionEntity.delete
      ..filePath = ''
      ..filename = ''
      ..mimeType = 'image/jpeg'
      ..createdAt = DateTime.now()
      ..synced = false
      ..syncedAt = null
      ..lastError = null
      ..attempts = 0
      ..lastAttemptAt = null
      ..nextAttemptAt = null;
    return isar.writeTxn(() => isar.qrisOutboxEntitys.put(entity));
  }

  Future<List<QrisOutboxEntity>> pending({int limit = 10}) async {
    final isar = await _isar;
    final now = DateTime.now();
    return isar.qrisOutboxEntitys
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

  Future<List<QrisOutboxEntity>> allUnsynced({int limit = 50}) async {
    final isar = await _isar;
    return isar.qrisOutboxEntitys
        .filter()
        .syncedEqualTo(false)
        .sortByCreatedAt()
        .limit(limit)
        .findAll();
  }

  Future<void> resetRetry({required int id}) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      final entity = await isar.qrisOutboxEntitys.get(id);
      if (entity == null) return;
      entity.nextAttemptAt = null;
      await isar.qrisOutboxEntitys.put(entity);
    });
  }

  Future<void> deleteById(int id) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      await isar.qrisOutboxEntitys.delete(id);
    });
  }

  Future<int> pruneSyncedOlderThan({
    required Duration age,
    int limit = 200,
  }) async {
    final isar = await _isar;
    final cutoff = DateTime.now().subtract(age);
    final rows = await isar.qrisOutboxEntitys
        .filter()
        .syncedEqualTo(true)
        .syncedAtLessThan(cutoff, include: true)
        .limit(limit)
        .findAll();
    if (rows.isEmpty) return 0;
    final ids = rows.map((e) => e.id).toList();
    await isar.writeTxn(() async {
      await isar.qrisOutboxEntitys.deleteAll(ids);
    });
    return ids.length;
  }

  Future<void> recordAttempt({required int id}) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      final entity = await isar.qrisOutboxEntitys.get(id);
      if (entity == null) return;
      entity
        ..attempts = entity.attempts + 1
        ..lastAttemptAt = DateTime.now();
      await isar.qrisOutboxEntitys.put(entity);
    });
  }

  Future<void> markSynced({required int id}) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      final entity = await isar.qrisOutboxEntitys.get(id);
      if (entity == null) return;
      entity
        ..synced = true
        ..syncedAt = DateTime.now()
        ..lastError = null
        ..nextAttemptAt = null;
      await isar.qrisOutboxEntitys.put(entity);
    });
  }

  Future<void> markFailed({required int id, required String message}) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      final entity = await isar.qrisOutboxEntitys.get(id);
      if (entity == null) return;
      entity.lastError = message;
      entity.nextAttemptAt = DateTime.now().add(computeRetryBackoff(entity.attempts));
      await isar.qrisOutboxEntitys.put(entity);
    });
  }

  Future<void> markPermanentFailed({required int id, required String message}) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      final entity = await isar.qrisOutboxEntitys.get(id);
      if (entity == null) return;
      entity
        ..lastError = message
        ..nextAttemptAt = DateTime.now().add(const Duration(days: 3650));
      await isar.qrisOutboxEntitys.put(entity);
    });
  }
}
