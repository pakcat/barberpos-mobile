import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:isar_community/isar.dart';

import '../../../../core/config/app_config.dart';
import '../datasources/attendance_remote_data_source.dart';
import '../entities/attendance_entity.dart';
import '../models/attendance_dto.dart';
import 'attendance_outbox_repository.dart';
import '../entities/attendance_outbox_entity.dart';

class AttendanceRepository {
  AttendanceRepository(
    this._isar, {
    AttendanceRemoteDataSource? restRemote,
    AppConfig? config,
    AttendanceOutboxRepository? outbox,
  })  : _config = config ?? Get.find<AppConfig>(),
        _rest = restRemote,
        _outbox =
            outbox ??
            (Get.isRegistered<AttendanceOutboxRepository>()
                ? Get.find<AttendanceOutboxRepository>()
                : null);

  final Isar _isar;
  final AttendanceRemoteDataSource? _rest;
  final AppConfig _config;
  final AttendanceOutboxRepository? _outbox;

  bool get _useRest => _config.backend == BackendMode.rest && _rest != null;

  Future<AttendanceEntity?> getTodayFor(String name) async {
    if (_useRest) {
      try {
        final today = DateTime.now();
        final list = await _rest!.getMonth(name, today);
        if (list.isNotEmpty) {
          final entities = list.map(_toEntity).toList();
          await _persistAll(entities);
          return entities.firstWhereOrNull(
            (a) => a.date.year == today.year && a.date.month == today.month && a.date.day == today.day,
          );
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
    if (_useRest) {
      try {
        if (entity.checkOut == null) {
          await _rest!.checkIn(
            entity.employeeName,
            employeeId: entity.employeeId?.toInt(),
            date: entity.date,
            source: entity.source,
          );
        } else {
          await _rest!.checkOut(
            entity.employeeName,
            employeeId: entity.employeeId?.toInt(),
            date: entity.date,
            source: entity.source,
          );
        }
      } on DioException catch (e) {
        // Queue only transient/offline errors. HTTP errors (403/401/etc) should not be retried blindly.
        if (e.response == null && _outbox != null) {
          final action = entity.checkOut == null
              ? AttendanceOutboxActionEntity.checkIn
              : AttendanceOutboxActionEntity.checkOut;
          await _outbox.enqueue(
            action: action,
            employeeName: entity.employeeName,
            employeeId: entity.employeeId,
            date: entity.date,
            source: entity.source,
          );
        }
        // Keep local state; surface error via logs/Sync screen.
      } catch (_) {
        // Keep local state if unexpected.
      }
    }
    return id;
  }

  Future<List<AttendanceEntity>> getMonth(String name, DateTime month) async {
    if (_useRest) {
      try {
        final remote = await _rest!.getMonth(name, month);
        if (remote.isNotEmpty) {
          final entities = remote.map(_toEntity).toList();
          await _persistAll(entities);
          return entities;
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

  Future<List<AttendanceEntity>> getDaily(DateTime date) async {
    if (_useRest) {
      try {
        final remote = await _rest!.getDaily(date);
        if (remote.isNotEmpty) {
          final entities = remote.map(_toEntity).toList();
          await _persistAll(entities);
          return entities;
        }
      } catch (_) {}
    }
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    final items = await _isar.attendanceEntitys
        .filter()
        .dateBetween(start, end, includeLower: true, includeUpper: false)
        .findAll();
    items.sort((a, b) => a.employeeName.compareTo(b.employeeName));
    return items;
  }

  Future<void> _persistAll(Iterable<AttendanceEntity> items) async {
    await _isar.writeTxn(() async {
      await _isar.attendanceEntitys.putAll(items.toList());
    });
  }

  AttendanceEntity _toEntity(AttendanceDto dto) => dto.toEntity();
}
