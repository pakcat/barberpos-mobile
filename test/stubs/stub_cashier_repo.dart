import 'package:barberpos_mobile/modules/cashier/data/entities/cart_item_entity.dart';
import 'package:barberpos_mobile/modules/cashier/data/repositories/cashier_repository.dart';

class StubCashierRepository implements CashierRepository {
  List<CartItemEntity> _cart = [];

  @override
  Future<List<CartItemEntity>> getCart() async => _cart;

  @override
  Future<void> saveCart(List<CartItemEntity> items) async {
    _cart = items;
  }
}
