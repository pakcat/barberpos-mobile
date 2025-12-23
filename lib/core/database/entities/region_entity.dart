import 'package:isar_community/isar.dart';

part 'region_entity.g.dart';

@collection
class RegionEntity {
  Id id = Isar.autoIncrement;
  @Index(unique: true, replace: true)
  late String name;
}

