import 'dart:convert';

import 'package:isar_community/isar.dart';

import '../../../../core/database/local_database.dart';
import '../../../../core/utils/retry_backoff.dart';
import '../entities/order_outbox_entity.dart';

class OrderOutboxRepository {
  OrderOutboxRepository(Future<LocalDatabase> dbReady) : _dbReady = dbReady;

  final Future<LocalDatabase> _dbReady;

  Future<Isar> get _isar async => (await _dbReady).isar;

  Future<int> enqueue({
    required String clientRef,
    required String pendingCode,
    required Map<String, dynamic> payload,
  }) async {
    final isar = await _isar;
    final entity = OrderOutboxEntity()
      ..clientRef = clientRef
      ..pendingCode = pendingCode
      ..payloadJson = jsonEncode(payload)
      ..createdAt = DateTime.now()
      ..synced = false
      ..attempts = 0
      ..lastAttemptAt = null
      ..nextAttemptAt = null;
    return isar.writeTxn(() => isar.orderOutboxEntitys.put(entity));
  }

  Future<List<OrderOutboxEntity>> pending({int limit = 20}) async {
    final isar = await _isar;
    final now = DateTime.now();
    return isar.orderOutboxEntitys
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
      final entity = await isar.orderOutboxEntitys.get(id);
      if (entity == null) return;
      entity
        ..attempts = entity.attempts + 1
        ..lastAttemptAt = DateTime.now();
      await isar.orderOutboxEntitys.put(entity);
    });
  }

  Future<void> markSynced({
    required int id,
    required String serverCode,
  }) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      final entity = await isar.orderOutboxEntitys.get(id);
      if (entity == null) return;
      entity.synced = true;
      entity.serverCode = serverCode;
      entity.syncedAt = DateTime.now();
      entity.lastError = null;
      entity.nextAttemptAt = null;
      await isar.orderOutboxEntitys.put(entity);
    });
  }

  Future<void> markFailed({required int id, required String message}) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      final entity = await isar.orderOutboxEntitys.get(id);
      if (entity == null) return;
      entity.lastError = message;
      entity.nextAttemptAt = DateTime.now().add(computeRetryBackoff(entity.attempts));
      await isar.orderOutboxEntitys.put(entity);
    });
  }

  Future<void> markPermanentFailed({required int id, required String message}) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      final entity = await isar.orderOutboxEntitys.get(id);
      if (entity == null) return;
      entity
        ..lastError = message
        ..nextAttemptAt = DateTime.now().add(const Duration(days: 3650));
      await isar.orderOutboxEntitys.put(entity);
    });
  }

  Future<List<OrderOutboxEntity>> allUnsynced({int limit = 200}) async {
    final isar = await _isar;
    return isar.orderOutboxEntitys
        .filter()
        .syncedEqualTo(false)
        .sortByCreatedAt()
        .limit(limit)
        .findAll();
  }

  Future<void> resetRetry({required int id}) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      final entity = await isar.orderOutboxEntitys.get(id);
      if (entity == null) return;
      entity.nextAttemptAt = null;
      await isar.orderOutboxEntitys.put(entity);
    });
  }

  Future<void> deleteById(int id) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      await isar.orderOutboxEntitys.delete(id);
    });
  }

  Future<int> pruneSyncedOlderThan({
    required Duration age,
    int limit = 500,
  }) async {
    final isar = await _isar;
    final cutoff = DateTime.now().subtract(age);
    final rows = await isar.orderOutboxEntitys
        .filter()
        .syncedEqualTo(true)
        .syncedAtLessThan(cutoff, include: true)
        .limit(limit)
        .findAll();
    if (rows.isEmpty) return 0;
    final ids = rows.map((e) => e.id).toList();
    await isar.writeTxn(() async {
      await isar.orderOutboxEntitys.deleteAll(ids);
    });
    return ids.length;
  }

  Future<void> cancelByPendingCode(String pendingCode) async {
    final isar = await _isar;
    final rows = await isar.orderOutboxEntitys.filter().pendingCodeEqualTo(pendingCode).findAll();
    if (rows.isEmpty) return;
    await isar.writeTxn(() async {
      await isar.orderOutboxEntitys.deleteAll(rows.map((e) => e.id).toList());
    });
  }
}
