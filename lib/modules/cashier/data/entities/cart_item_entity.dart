import 'package:isar_community/isar.dart';

part 'cart_item_entity.g.dart';

@collection
class CartItemEntity {
  Id id = Isar.autoIncrement;
  late String name;
  late String category;
  late int price;
  int qty = 1;
}

