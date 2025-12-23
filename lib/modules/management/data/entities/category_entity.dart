import 'package:isar_community/isar.dart';

part 'category_entity.g.dart';

@collection
class CategoryEntity {
  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  late String name;
}

