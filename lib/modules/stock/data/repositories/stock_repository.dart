import 'package:barberpos_mobile/modules/product/data/entities/product_entity.dart';
import 'package:isar_community/isar.dart';

import '../entities/stock_entity.dart';

import '../datasources/stock_firestore_data_source.dart';

class StockRepository {
  StockRepository(this._isar, {this.remote});

  final Isar _isar;
  final StockFirestoreDataSource? remote;

  Future<List<StockEntity>> getAll() async {
    // Selalu sinkron dari produk trackStock agar sesuai dengan perubahan stok produk.
    final products = await _isar.productEntitys.filter().trackStockEqualTo(true).findAll();
    final derived = products.map(_mapFromProduct).toList();
    await replaceAll(derived);
    return derived;
  }

  Future<Id> upsert(StockEntity stock) async {
    final id = await _isar.writeTxn(() => _isar.stockEntitys.put(stock));
    if (remote != null) {
      try {
        await remote!.upsert(stock);
      } catch (_) {
        // ignore
      }
    }
    return id;
  }

  Future<void> replaceAll(Iterable<StockEntity> items) async {
    await _isar.writeTxn(() async {
      await _isar.stockEntitys.clear();
      await _isar.stockEntitys.putAll(items.toList());
    });
  }

  Future<void> delete(Id id) async {
    final item = await _isar.stockEntitys.get(id);
    await _isar.writeTxn(() => _isar.stockEntitys.delete(id));
    if (remote != null && item != null) {
      try {
        await remote!.delete(item);
      } catch (_) {
        // ignore
      }
    }
  }

  StockEntity _mapFromProduct(ProductEntity p) {
    final stock = StockEntity()
      ..id = p.id
      ..name = p.name
      ..category = p.category
      ..image = p.image
      ..stock = p.stock
      ..transactions = 0;
    return stock;
  }
}

