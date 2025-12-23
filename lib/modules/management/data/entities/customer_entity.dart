import 'package:isar_community/isar.dart';

part 'customer_entity.g.dart';

@collection
class CustomerEntity {
  Id id = Isar.autoIncrement;
  late String name;
  late String phone;
  String email = '';
  String address = '';
}

