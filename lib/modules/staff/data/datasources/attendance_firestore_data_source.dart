import 'package:cloud_firestore/cloud_firestore.dart';

import '../entities/attendance_entity.dart';

class AttendanceFirestoreDataSource {
  AttendanceFirestoreDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Future<AttendanceEntity?> getTodayFor(String name) async {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = start.add(const Duration(days: 1));
    final snap = await _firestore
        .collection('attendance')
        .where('employeeName', isEqualTo: name)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThan: Timestamp.fromDate(end))
        .orderBy('date', descending: true)
        .limit(1)
        .get();
    if (snap.docs.isEmpty) return null;
    return _toEntity(snap.docs.first);
  }

  Future<List<AttendanceEntity>> getMonth(String name, DateTime month) async {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);
    final snap = await _firestore
        .collection('attendance')
        .where('employeeName', isEqualTo: name)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThan: Timestamp.fromDate(end))
        .orderBy('date', descending: true)
        .get();
    return snap.docs.map(_toEntity).toList();
  }

  Future<void> upsert(AttendanceEntity entity) async {
    await _firestore.collection('attendance').add({
      'employeeName': entity.employeeName,
      'date': Timestamp.fromDate(entity.date),
      'checkIn': entity.checkIn != null ? Timestamp.fromDate(entity.checkIn!) : null,
      'checkOut': entity.checkOut != null ? Timestamp.fromDate(entity.checkOut!) : null,
      'status': entity.status.name,
      'source': entity.source,
    });
  }

  AttendanceEntity _toEntity(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return AttendanceEntity()
      ..id = doc.id.hashCode
      ..employeeName = data['employeeName']?.toString() ?? ''
      ..date = (data['date'] as Timestamp?)?.toDate() ?? DateTime.now()
      ..checkIn = (data['checkIn'] as Timestamp?)?.toDate()
      ..checkOut = (data['checkOut'] as Timestamp?)?.toDate()
      ..status = _statusFromString(data['status']?.toString() ?? '')
      ..source = data['source']?.toString() ?? '';
  }

  AttendanceStatus _statusFromString(String value) {
    switch (value.toLowerCase()) {
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
