import 'package:isar_community/isar.dart';

part 'product_entity.g.dart';

@collection
class ProductEntity {
  Id id = Isar.autoIncrement;
  late String name;
  late String category;
  late int price;
  String image = '';
  bool trackStock = false;
  int stock = 0;
  int minStock = 0;
}

