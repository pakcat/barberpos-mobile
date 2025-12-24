import 'package:isar_community/isar.dart';

import '../datasources/product_remote_data_source.dart';
import '../entities/product_entity.dart';

class ProductRepository {
  ProductRepository(this._isar, {this.restRemote});

  final Isar _isar;
  final ProductRemoteDataSource? restRemote;

  Future<List<ProductEntity>> getAll() async {
    if (restRemote != null) {
      try {
        final items = await restRemote!.fetchAll();
        await replaceAllFromRemote(items);
        return _isar.productEntitys.filter().deletedEqualTo(false).findAll();
      } catch (_) {
        // Fallback to cached data
      }
    }
    return _isar.productEntitys.filter().deletedEqualTo(false).findAll();
  }

  Future<ProductEntity?> getById(Id id) => _isar.productEntitys.get(id);

  Future<Id> upsertLocal(ProductEntity product) async {
    return _isar.writeTxn(() => _isar.productEntitys.put(product));
  }

  Future<Id> upsert(ProductEntity product) async {
    final originalId = product.id;
    var toSave = product;
    if (restRemote != null) {
      try {
        toSave = await restRemote!.upsert(product);
      } catch (_) {
        // keep local-only if API unavailable
      }
    }

    return _isar.writeTxn(() async {
      if (toSave.id != originalId) {
        await _isar.productEntitys.delete(originalId);
      }
      return _isar.productEntitys.put(toSave);
    });
  }

  Future<void> replaceAll(Iterable<ProductEntity> items) async => replaceAllFromRemote(items);

  Future<void> replaceAllFromRemote(Iterable<ProductEntity> remoteItems) async {
    final remote = remoteItems.toList();
    final localUnsynced = await _isar.productEntitys
        .filter()
        .syncStatusEqualTo(ProductSyncStatusEntity.pending)
        .or()
        .syncStatusEqualTo(ProductSyncStatusEntity.failed)
        .or()
        .deletedEqualTo(true)
        .findAll();

    final localById = {for (final p in localUnsynced) p.id: p};
    final merged = <ProductEntity>[];
    for (final r in remote) {
      final local = localById[r.id];
      if (local != null) {
        merged.add(local);
      } else {
        merged.add(r);
      }
    }
    // Add local-only unsynced that aren't in remote
    for (final p in localUnsynced) {
      if (!remote.any((r) => r.id == p.id)) {
        merged.add(p);
      }
    }

    await _isar.writeTxn(() async {
      await _isar.productEntitys.clear();
      await _isar.productEntitys.putAll(merged);
    });
  }

  Future<void> markSyncedFromServer({
    required int localId,
    required ProductEntity server,
  }) async {
    final cleaned = server
      ..syncStatus = ProductSyncStatusEntity.synced
      ..syncError = ''
      ..deleted = false;

    await _isar.writeTxn(() async {
      // Remove local temp row if needed.
      if (localId != cleaned.id) {
        await _isar.productEntitys.delete(localId);
      }
      await _isar.productEntitys.put(cleaned);
    });
  }

  Future<void> markPending(int id) async {
    final existing = await _isar.productEntitys.get(id);
    if (existing == null) return;
    existing
      ..syncStatus = ProductSyncStatusEntity.pending
      ..syncError = '';
    await _isar.writeTxn(() => _isar.productEntitys.put(existing));
  }

  Future<void> markFailed(int id, String message) async {
    final existing = await _isar.productEntitys.get(id);
    if (existing == null) return;
    existing
      ..syncStatus = ProductSyncStatusEntity.failed
      ..syncError = message.trim();
    await _isar.writeTxn(() => _isar.productEntitys.put(existing));
  }

  Future<void> markDeletedPending(int id) async {
    final existing = await _isar.productEntitys.get(id);
    if (existing == null) return;
    existing
      ..deleted = true
      ..syncStatus = ProductSyncStatusEntity.pending
      ..syncError = '';
    await _isar.writeTxn(() => _isar.productEntitys.put(existing));
  }

  Future<void> delete(Id id) async {
    await _isar.writeTxn(() => _isar.productEntitys.delete(id));
    if (restRemote != null) {
      try {
        await restRemote!.delete(id);
      } catch (_) {
        // keep local-only if API unavailable
      }
    }
  }
}
