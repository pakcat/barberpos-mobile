import 'package:isar_community/isar.dart';

import '../../../../core/database/local_database.dart';
import '../../../../core/utils/retry_backoff.dart';
import '../entities/product_image_outbox_entity.dart';

class ProductImageOutboxRepository {
  ProductImageOutboxRepository(Future<LocalDatabase> dbReady) : _dbReady = dbReady;

  final Future<LocalDatabase> _dbReady;

  Future<Isar> get _isar async => (await _dbReady).isar;

  Future<int> enqueue({
    required int localProductId,
    required String filePath,
    required String filename,
    required String mimeType,
  }) async {
    final isar = await _isar;
    final entity = ProductImageOutboxEntity()
      ..localProductId = localProductId
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
    return isar.writeTxn(() => isar.productImageOutboxEntitys.put(entity));
  }

  Future<List<ProductImageOutboxEntity>> pending({int limit = 20}) async {
    final isar = await _isar;
    final now = DateTime.now();
    return isar.productImageOutboxEntitys
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

  Future<List<ProductImageOutboxEntity>> allUnsynced({int limit = 200}) async {
    final isar = await _isar;
    return isar.productImageOutboxEntitys
        .filter()
        .syncedEqualTo(false)
        .sortByCreatedAt()
        .limit(limit)
        .findAll();
  }

  Future<void> resetRetry({required int id}) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      final entity = await isar.productImageOutboxEntitys.get(id);
      if (entity == null) return;
      entity.nextAttemptAt = null;
      await isar.productImageOutboxEntitys.put(entity);
    });
  }

  Future<void> deleteById(int id) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      await isar.productImageOutboxEntitys.delete(id);
    });
  }

  Future<int> pruneSyncedOlderThan({
    required Duration age,
    int limit = 500,
  }) async {
    final isar = await _isar;
    final cutoff = DateTime.now().subtract(age);
    final rows = await isar.productImageOutboxEntitys
        .filter()
        .syncedEqualTo(true)
        .syncedAtLessThan(cutoff, include: true)
        .limit(limit)
        .findAll();
    if (rows.isEmpty) return 0;
    final ids = rows.map((e) => e.id).toList();
    await isar.writeTxn(() async {
      await isar.productImageOutboxEntitys.deleteAll(ids);
    });
    return ids.length;
  }

  Future<int> pruneFailedOlderThan({
    required Duration age,
    int limit = 500,
  }) async {
    final isar = await _isar;
    final cutoff = DateTime.now().subtract(age);
    final rows = await isar.productImageOutboxEntitys
        .filter()
        .syncedEqualTo(false)
        .lastErrorIsNotNull()
        .createdAtLessThan(cutoff, include: true)
        .limit(limit)
        .findAll();
    if (rows.isEmpty) return 0;
    final ids = rows.map((e) => e.id).toList();
    await isar.writeTxn(() async {
      await isar.productImageOutboxEntitys.deleteAll(ids);
    });
    return ids.length;
  }

  Future<void> recordAttempt({required int id}) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      final entity = await isar.productImageOutboxEntitys.get(id);
      if (entity == null) return;
      entity
        ..attempts = entity.attempts + 1
        ..lastAttemptAt = DateTime.now();
      await isar.productImageOutboxEntitys.put(entity);
    });
  }

  Future<void> markSynced({required int id}) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      final entity = await isar.productImageOutboxEntitys.get(id);
      if (entity == null) return;
      entity
        ..synced = true
        ..syncedAt = DateTime.now()
        ..lastError = null
        ..nextAttemptAt = null;
      await isar.productImageOutboxEntitys.put(entity);
    });
  }

  Future<void> markFailed({required int id, required String message}) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      final entity = await isar.productImageOutboxEntitys.get(id);
      if (entity == null) return;
      entity.lastError = message;
      entity.nextAttemptAt = DateTime.now().add(computeRetryBackoff(entity.attempts));
      await isar.productImageOutboxEntitys.put(entity);
    });
  }

  Future<void> markPermanentFailed({required int id, required String message}) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      final entity = await isar.productImageOutboxEntitys.get(id);
      if (entity == null) return;
      entity
        ..lastError = message
        ..nextAttemptAt = DateTime.now().add(const Duration(days: 3650));
      await isar.productImageOutboxEntitys.put(entity);
    });
  }
}
