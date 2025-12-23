import 'package:isar_community/isar.dart';

import '../entities/cart_item_entity.dart';

class CashierRepository {
  CashierRepository(this._isar);

  final Isar _isar;

  Future<List<CartItemEntity>> getCart() => _isar.cartItemEntitys.where().findAll();

  Future<void> saveCart(List<CartItemEntity> items) async {
    await _isar.writeTxn(() async {
      await _isar.cartItemEntitys.clear();
      await _isar.cartItemEntitys.putAll(items);
    });
  }
}

