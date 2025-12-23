import 'package:isar_community/isar.dart';

part 'closing_history_entity.g.dart';

@collection
class ClosingHistoryEntity {
  Id id = Isar.autoIncrement;
  late DateTime tanggal;
  late String shift;
  late String karyawan;
  String? shiftId;
  String operatorName = '';
  late int total;
  late String status;
  String catatan = '';
  String fisik = '';
}

