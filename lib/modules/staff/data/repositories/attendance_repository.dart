import 'package:get/get.dart';
import 'package:isar_community/isar.dart';

import '../../../../core/config/app_config.dart';
import '../datasources/attendance_firestore_data_source.dart';
import '../entities/attendance_entity.dart';

class AttendanceRepository {
  AttendanceRepository(
    this._isar, {
    AttendanceFirestoreDataSource? remote,
    AppConfig? config,
  })  : _config = config ?? Get.find<AppConfig>(),
        _remote = remote;

  final Isar _isar;
  final AttendanceFirestoreDataSource? _remote;
  final AppConfig _config;

  bool get _useFirebase => _config.backend == BackendMode.firebase && _remote != null;

  Future<AttendanceEntity?> getTodayFor(String name) async {
    if (_useFirebase) {
      try {
        final remote = await _remote!.getTodayFor(name);
        if (remote != null) {
          await _persist(remote);
          return remote;
        }
      } catch (_) {}
    }
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = start.add(const Duration(days: 1));
    return _isar.attendanceEntitys
        .filter()
        .employeeNameEqualTo(name)
        .dateBetween(start, end, includeLower: true, includeUpper: false)
        .sortByDateDesc()
        .findFirst();
  }

  Future<Id> upsert(AttendanceEntity entity) async {
    final id = await _isar.writeTxn(() => _isar.attendanceEntitys.put(entity));
    if (_useFirebase) {
      _remote!.upsert(entity);
    }
    return id;
  }

  Future<List<AttendanceEntity>> getMonth(String name, DateTime month) async {
    if (_useFirebase) {
      try {
        final remote = await _remote!.getMonth(name, month);
        if (remote.isNotEmpty) {
          await _isar.writeTxn(() async {
            // replace existing month records for that name
            final start = DateTime(month.year, month.month, 1);
            final end = DateTime(month.year, month.month + 1, 1);
            final existing = await _isar.attendanceEntitys
                .filter()
                .employeeNameEqualTo(name)
                .dateBetween(start, end, includeLower: true, includeUpper: false)
                .findAll();
            await _isar.attendanceEntitys.deleteAll(existing.map((e) => e.id).toList());
            await _isar.attendanceEntitys.putAll(remote);
          });
          return remote;
        }
      } catch (_) {}
    }
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);
    return _isar.attendanceEntitys
        .filter()
        .employeeNameEqualTo(name)
        .dateBetween(start, end, includeLower: true, includeUpper: false)
        .sortByDateDesc()
        .findAll();
  }

  Future<List<String>> getStaffNames() async {
    final names = <String>{};
    final all = await _isar.attendanceEntitys.where().findAll();
    for (final a in all) {
      if (a.employeeName.isNotEmpty) names.add(a.employeeName);
    }
    return names.toList();
  }

  Future<void> _persist(AttendanceEntity entity) async {
    await _isar.writeTxn(() => _isar.attendanceEntitys.put(entity));
  }
}

