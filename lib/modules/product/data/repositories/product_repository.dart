import 'package:isar_community/isar.dart';

import '../entities/product_entity.dart';

import '../datasources/product_firestore_data_source.dart';

class ProductRepository {
  ProductRepository(this._isar, {this.remote});

  final Isar _isar;
  final ProductFirestoreDataSource? remote;

  Future<List<ProductEntity>> getAll() async {
    if (remote != null) {
      try {
        final items = await remote!.fetchAll();
        await replaceAll(items);
        return items;
      } catch (_) {
        // Fallback
      }
    }
    return _isar.productEntitys.where().findAll();
  }

  Future<ProductEntity?> getById(Id id) => _isar.productEntitys.get(id);

  Future<Id> upsert(ProductEntity product) async {
    final id = await _isar.writeTxn(() => _isar.productEntitys.put(product));
    if (remote != null) {
      try {
        await remote!.upsert(product);
      } catch (_) {
        // ignore
      }
    }
    return id;
  }

  Future<void> replaceAll(Iterable<ProductEntity> items) async {
    await _isar.writeTxn(() async {
      await _isar.productEntitys.clear();
      await _isar.productEntitys.putAll(items.toList());
    });
  }

  Future<void> delete(Id id) async {
    final item = await _isar.productEntitys.get(id);
    await _isar.writeTxn(() => _isar.productEntitys.delete(id));
    if (remote != null && item != null) {
      try {
        await remote!.delete(item);
      } catch (_) {
        // ignore
      }
    }
  }
}

