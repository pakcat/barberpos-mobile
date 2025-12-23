import 'package:isar_community/isar.dart';

part 'attendance_entity.g.dart';

@collection
class AttendanceEntity {
  Id id = Isar.autoIncrement;
  int? employeeId;
  late String employeeName;
  late DateTime date; // only date part relevant
  DateTime? checkIn;
  DateTime? checkOut;
  @enumerated
  AttendanceStatus status = AttendanceStatus.present;
  String source = 'cashier';
}

enum AttendanceStatus { present, leave, sick, off }

