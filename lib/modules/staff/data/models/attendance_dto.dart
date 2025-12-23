import 'package:isar_community/isar.dart';

import '../entities/attendance_entity.dart';

class AttendanceDto {
  AttendanceDto({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.date,
    required this.status,
    this.checkIn,
    this.checkOut,
    this.source = 'cashier',
  });

  final String id;
  final int? employeeId;
  final String employeeName;
  final DateTime date;
  final String status;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final String source;

  factory AttendanceDto.fromJson(Map<String, dynamic> json) {
    return AttendanceDto(
      id: json['id']?.toString() ?? '',
      employeeId: json['employeeId'] != null ? int.tryParse(json['employeeId'].toString()) : null,
      employeeName: json['employeeName']?.toString() ?? '',
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      status: json['status']?.toString() ?? 'present',
      checkIn: json['checkIn'] != null ? DateTime.tryParse(json['checkIn'].toString()) : null,
      checkOut: json['checkOut'] != null ? DateTime.tryParse(json['checkOut'].toString()) : null,
      source: json['source']?.toString() ?? 'cashier',
    );
  }

  AttendanceEntity toEntity() {
    final entity = AttendanceEntity()
      ..employeeId = employeeId
      ..employeeName = employeeName
      ..date = DateTime(date.year, date.month, date.day)
      ..status = _statusFromString(status)
      ..checkIn = checkIn
      ..checkOut = checkOut
      ..source = source;
    entity.id = int.tryParse(id) ?? Isar.autoIncrement;
    return entity;
  }

  AttendanceStatus _statusFromString(String v) {
    switch (v.toLowerCase()) {
      case 'leave':
        return AttendanceStatus.leave;
      case 'sick':
        return AttendanceStatus.sick;
      case 'off':
        return AttendanceStatus.off;
      default:
        return AttendanceStatus.present;
    }
  }
}

