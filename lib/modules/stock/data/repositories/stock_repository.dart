import 'package:barberpos_mobile/modules/product/data/entities/product_entity.dart';
import 'package:isar_community/isar.dart';

import '../datasources/stock_remote_data_source.dart';
import '../entities/stock_adjustment_outbox_entity.dart';
import '../entities/stock_entity.dart';

class StockRepository {
  StockRepository(this._isar, {this.restRemote});

  final Isar _isar;
  final StockRemoteDataSource? restRemote;

  Future<List<StockEntity>> getAll() async {
    if (restRemote != null) {
      try {
        final items = await restRemote!.fetchAll();
        await replaceAll(items);
        return items;
      } catch (_) {}
    }
    // Selalu sinkron dari produk trackStock agar sesuai dengan perubahan stok produk.
    final products = await _isar.productEntitys.filter().trackStockEqualTo(true).findAll();
    final derived = products.map(_mapFromProduct).toList();
    await replaceAll(derived);
    return derived;
  }

  Future<Id> upsert(StockEntity stock) async {
    return _isar.writeTxn(() => _isar.stockEntitys.put(stock));
  }

  Future<StockEntity?> adjustRemote({
    required int stockId,
    required int change,
    required String type,
    String? note,
    int? productId,
  }) async {
    final remote = restRemote;
    if (remote == null) return null;

    await remote.adjust(
      stockId: stockId,
      change: change,
      type: type,
      note: note,
      productId: productId,
    );

    final latest = await remote.fetchAll();
    await replaceAll(latest);

    for (final item in latest) {
      if (item.id == stockId) return item;
    }
    return null;
  }

  Future<int> enqueueAdjustment({
    required int stockId,
    required int change,
    required String type,
    String? note,
    int? productId,
  }) async {
    final entity = StockAdjustmentOutboxEntity()
      ..stockId = stockId
      ..change = change
      ..type = type
      ..note = note?.trim() ?? ''
      ..productId = productId
      ..createdAt = DateTime.now()
      ..synced = false;
    return _isar.writeTxn(() async {
      return _isar.stockAdjustmentOutboxEntitys.put(entity);
    });
  }

  Future<List<StockAdjustmentOutboxEntity>> getPendingAdjustments({int limit = 50}) async {
    return _isar.stockAdjustmentOutboxEntitys
        .filter()
        .syncedEqualTo(false)
        .sortByCreatedAt()
        .limit(limit)
        .findAll();
  }

  Future<void> markAdjustmentsSynced(List<int> ids) async {
    if (ids.isEmpty) return;
    await _isar.writeTxn(() async {
      final rows = await _isar.stockAdjustmentOutboxEntitys.getAll(ids);
      final updated = rows.whereType<StockAdjustmentOutboxEntity>().toList();
      for (final e in updated) {
        e.synced = true;
      }
      await _isar.stockAdjustmentOutboxEntitys.putAll(updated);
    });
  }

  Future<List<Map<String, dynamic>>> historyRemote(int stockId, {int limit = 50}) async {
    final remote = restRemote;
    if (remote == null) return const [];
    try {
      return await remote.history(stockId, limit: limit);
    } catch (_) {
      return const [];
    }
  }

  Future<void> replaceAll(Iterable<StockEntity> items) async {
    await _isar.writeTxn(() async {
      await _isar.stockEntitys.clear();
      await _isar.stockEntitys.putAll(items.toList());
    });
  }

  Future<void> delete(Id id) async => _isar.writeTxn(() => _isar.stockEntitys.delete(id));

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
