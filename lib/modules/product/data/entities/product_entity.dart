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
  bool deleted = false;
  @enumerated
  ProductSyncStatusEntity syncStatus = ProductSyncStatusEntity.synced;
  String syncError = '';
}

// Keep new values appended to preserve Isar enum indices for existing data.
enum ProductSyncStatusEntity { synced, pending, failed }

