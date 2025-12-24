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

  Future<EmployeeEntity> upsert(EmployeeEntity employee, {String? pin}) async {
    final remoteSource = remote;

    if (remoteSource != null && employee.id == 0) {
      try {
        final saved = await remoteSource.upsert(employee, pin: pin);
        await _isar.writeTxn(() => _isar.employeeEntitys.put(saved));
        return saved;
      } catch (_) {
        // fall back to local
      }
    }

    final persistedId = await _isar.writeTxn(() => _isar.employeeEntitys.put(employee));
    employee.id = persistedId;

    if (remoteSource == null) return employee;

    try {
      final saved = await remoteSource.upsert(employee, pin: pin);
      if (saved.id != 0 && saved.id != employee.id) {
        await _isar.writeTxn(() async {
          await _isar.employeeEntitys.delete(employee.id);
          await _isar.employeeEntitys.put(saved);
        });
        return saved;
      }
      await _isar.writeTxn(() => _isar.employeeEntitys.put(saved));
      return saved;
    } catch (_) {
      return employee;
    }
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
