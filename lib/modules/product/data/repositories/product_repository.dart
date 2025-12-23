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
        await replaceAll(items);
        return items;
      } catch (_) {
        // Fallback to cached data
      }
    }
    return _isar.productEntitys.where().findAll();
  }

  Future<ProductEntity?> getById(Id id) => _isar.productEntitys.get(id);

  Future<Id> upsert(ProductEntity product) async =>
      _isar.writeTxn(() => _isar.productEntitys.put(product));

  Future<void> replaceAll(Iterable<ProductEntity> items) async {
    await _isar.writeTxn(() async {
      await _isar.productEntitys.clear();
      await _isar.productEntitys.putAll(items.toList());
    });
  }

  Future<void> delete(Id id) async => _isar.writeTxn(() => _isar.productEntitys.delete(id));
}
