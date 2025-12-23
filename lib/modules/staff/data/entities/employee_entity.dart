import 'package:isar_community/isar.dart';

part 'employee_entity.g.dart';

@collection
class EmployeeEntity {
  Id id = Isar.autoIncrement;
  late String name;
  late String role;
  late String phone;
  late String email;
  late DateTime joinDate;
  double? commission;
  bool active = true;
}

