import 'dart:convert';

import 'package:isar_community/isar.dart';

import '../../../../core/database/local_database.dart';
import '../../../../core/utils/retry_backoff.dart';
import '../entities/product_outbox_entity.dart';

class ProductOutboxRepository {
  ProductOutboxRepository(Future<LocalDatabase> dbReady) : _dbReady = dbReady;

  final Future<LocalDatabase> _dbReady;

  Future<Isar> get _isar async => (await _dbReady).isar;

  Future<int> upsertPending({
    required int localProductId,
    required ProductOutboxActionEntity action,
    required Map<String, dynamic> payload,
  }) async {
    final isar = await _isar;
    final existing = await isar.productOutboxEntitys
        .filter()
        .localProductIdEqualTo(localProductId)
        .actionEqualTo(action)
        .syncedEqualTo(false)
        .sortByCreatedAtDesc()
        .findFirst();

    final entity = existing ?? ProductOutboxEntity();
    entity
      ..localProductId = localProductId
      ..action = action
      ..payloadJson = jsonEncode(payload)
      ..createdAt = existing?.createdAt ?? DateTime.now()
      ..synced = false
      ..syncedAt = null
      ..lastError = null
      ..serverId = null
      ..nextAttemptAt = null;

    return isar.writeTxn(() => isar.productOutboxEntitys.put(entity));
  }

  Future<List<ProductOutboxEntity>> pending({int limit = 20}) async {
    final isar = await _isar;
    final now = DateTime.now();
    return isar.productOutboxEntitys
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

  Future<void> recordAttempt({required int id}) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      final entity = await isar.productOutboxEntitys.get(id);
      if (entity == null) return;
      entity
        ..attempts = entity.attempts + 1
        ..lastAttemptAt = DateTime.now();
      await isar.productOutboxEntitys.put(entity);
    });
  }

  Future<void> markSynced({
    required int id,
    String? serverId,
  }) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      final entity = await isar.productOutboxEntitys.get(id);
      if (entity == null) return;
      entity
        ..synced = true
        ..syncedAt = DateTime.now()
        ..lastError = null
        ..serverId = serverId
        ..nextAttemptAt = null;
      await isar.productOutboxEntitys.put(entity);
    });
  }

  Future<void> markFailed({required int id, required String message}) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      final entity = await isar.productOutboxEntitys.get(id);
      if (entity == null) return;
      entity.lastError = message;
      entity.nextAttemptAt = DateTime.now().add(computeRetryBackoff(entity.attempts));
      await isar.productOutboxEntitys.put(entity);
    });
  }

  Future<void> markPermanentFailed({required int id, required String message}) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      final entity = await isar.productOutboxEntitys.get(id);
      if (entity == null) return;
      entity
        ..lastError = message
        ..nextAttemptAt = DateTime.now().add(const Duration(days: 3650));
      await isar.productOutboxEntitys.put(entity);
    });
  }

  Future<List<ProductOutboxEntity>> allUnsynced({int limit = 200}) async {
    final isar = await _isar;
    return isar.productOutboxEntitys
        .filter()
        .syncedEqualTo(false)
        .sortByCreatedAt()
        .limit(limit)
        .findAll();
  }

  Future<void> resetRetry({required int id}) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      final entity = await isar.productOutboxEntitys.get(id);
      if (entity == null) return;
      entity.nextAttemptAt = null;
      await isar.productOutboxEntitys.put(entity);
    });
  }

  Future<void> deleteById(int id) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      await isar.productOutboxEntitys.delete(id);
    });
  }

  Future<int> pruneSyncedOlderThan({
    required Duration age,
    int limit = 500,
  }) async {
    final isar = await _isar;
    final cutoff = DateTime.now().subtract(age);
    final rows = await isar.productOutboxEntitys
        .filter()
        .syncedEqualTo(true)
        .syncedAtLessThan(cutoff, include: true)
        .limit(limit)
        .findAll();
    if (rows.isEmpty) return 0;
    final ids = rows.map((e) => e.id).toList();
    await isar.writeTxn(() async {
      await isar.productOutboxEntitys.deleteAll(ids);
    });
    return ids.length;
  }

  Future<void> cancelForLocalId(int localProductId) async {
    final isar = await _isar;
    final rows = await isar.productOutboxEntitys
        .filter()
        .localProductIdEqualTo(localProductId)
        .syncedEqualTo(false)
        .findAll();
    if (rows.isEmpty) return;
    await isar.writeTxn(() async {
      await isar.productOutboxEntitys.deleteAll(rows.map((e) => e.id).toList());
    });
  }
}
