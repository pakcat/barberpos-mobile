import 'package:isar_community/isar.dart';

part 'employee_entity.g.dart';

@collection
class EmployeeEntity {
  Id id = Isar.autoIncrement;
  late String name;
  String role = 'Staff';
  List<String> modules = [];
  late String phone;
  late String email;
  late DateTime joinDate;
  double? commission;
  bool active = true;
}

