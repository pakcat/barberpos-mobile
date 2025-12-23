import 'package:isar_community/isar.dart';

import '../entities/employee_entity.dart';

class StaffRepository {
  StaffRepository(this._isar);

  final Isar _isar;

  Future<List<EmployeeEntity>> getAll() => _isar.employeeEntitys.where().findAll();

  Future<Id> upsert(EmployeeEntity employee) {
    return _isar.writeTxn(() => _isar.employeeEntitys.put(employee));
  }

  Future<void> replaceAll(Iterable<EmployeeEntity> items) async {
    await _isar.writeTxn(() async {
      await _isar.employeeEntitys.clear();
      await _isar.employeeEntitys.putAll(items.toList());
    });
  }

  Future<void> delete(Id id) async {
    await _isar.writeTxn(() => _isar.employeeEntitys.delete(id));
  }
}

