import 'package:isar_community/isar.dart';

part 'attendance_outbox_entity.g.dart';

@collection
class AttendanceOutboxEntity {
  Id id = Isar.autoIncrement;

  @enumerated
  AttendanceOutboxActionEntity action = AttendanceOutboxActionEntity.checkIn;

  int? employeeId;
  String employeeName = '';
  DateTime date = DateTime.now(); // date-only
  String source = 'employee';

  DateTime createdAt = DateTime.now();

  bool synced = false;
  DateTime? syncedAt;
  String? lastError;
  int attempts = 0;
  DateTime? lastAttemptAt;
  DateTime? nextAttemptAt;
}

// Keep new values appended to preserve Isar enum indices for existing data.
enum AttendanceOutboxActionEntity { checkIn, checkOut }

