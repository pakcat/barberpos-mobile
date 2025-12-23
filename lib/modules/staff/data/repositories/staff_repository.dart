import 'package:isar_community/isar.dart';

import '../datasources/staff_remote_data_source.dart';
import '../entities/employee_entity.dart';

class StaffRepository {
  StaffRepository(this._isar, {this.remote});

  final Isar _isar;
  final StaffRemoteDataSource? remote;

  Future<List<EmployeeEntity>> getAll() async {
    if (remote != null) {
      try {
        final items = await remote!.fetchAll();
        await replaceAll(items);
        return items;
      } catch (_) {}
    }
    return _isar.employeeEntitys.where().findAll();
  }

  Future<Id> upsert(EmployeeEntity employee) async {
    if (remote != null) {
      try {
        final saved = await remote!.upsert(employee);
        employee.id = saved.id;
      } catch (_) {}
    }
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
    if (remote != null) {
      try {
        await remote!.delete(id);
      } catch (_) {}
    }
  }
}
