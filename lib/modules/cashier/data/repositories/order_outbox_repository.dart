import 'dart:convert';

import 'package:isar_community/isar.dart';

import '../../../../core/database/local_database.dart';
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
      ..synced = false;
    return isar.writeTxn(() => isar.orderOutboxEntitys.put(entity));
  }

  Future<List<OrderOutboxEntity>> pending({int limit = 20}) async {
    final isar = await _isar;
    return isar.orderOutboxEntitys
        .filter()
        .syncedEqualTo(false)
        .sortByCreatedAt()
        .limit(limit)
        .findAll();
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
      await isar.orderOutboxEntitys.put(entity);
    });
  }

  Future<void> markFailed({required int id, required String message}) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      final entity = await isar.orderOutboxEntitys.get(id);
      if (entity == null) return;
      entity.lastError = message;
      await isar.orderOutboxEntitys.put(entity);
    });
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

