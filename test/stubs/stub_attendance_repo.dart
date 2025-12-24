import 'package:barberpos_mobile/modules/staff/data/entities/attendance_entity.dart';
import 'package:barberpos_mobile/modules/staff/data/repositories/attendance_repository.dart';
import 'package:isar_community/isar.dart';

class StubAttendanceRepository implements AttendanceRepository {
  final List<AttendanceEntity> _list = [];

  @override
  Future<AttendanceEntity?> getTodayFor(String name) async {
    for (final e in _list) {
      if (e.employeeName == name) return e;
    }
    return null;
  }

  @override
  Future<List<AttendanceEntity>> getMonth(String name, DateTime month) async => _list;

  @override
  Future<Id> upsert(AttendanceEntity entity) async {
    entity.id = entity.id == Isar.autoIncrement ? _list.length + 1 : entity.id;
    _list.add(entity);
    return entity.id;
  }

  @override
  Future<List<String>> getStaffNames() async {
    return _list.map((e) => e.employeeName).where((e) => e.isNotEmpty).toSet().toList();
  }

  @override
  Future<List<AttendanceEntity>> getDaily(DateTime date) async => _list;
}
