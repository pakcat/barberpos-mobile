import 'package:isar_community/isar.dart';

part 'stock_entity.g.dart';

@collection
class StockEntity {
  Id id = Isar.autoIncrement;
  late String name;
  late String category;
  late String image;
  late int stock;
  late int transactions;
}

