import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isar_community/isar.dart';

import '../entities/employee_entity.dart';

class StaffFirestoreDataSource {
  StaffFirestoreDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Future<List<EmployeeEntity>> fetchAll({int limit = 300}) async {
    final snap = await _firestore.collection('staff').orderBy('name').limit(limit).get();
    return snap.docs.map(_toEntity).toList();
  }

  Future<EmployeeEntity> upsert(EmployeeEntity employee) async {
    final docId = _docIdFor(employee);
    final data = _toMap(employee);
    await _firestore.collection('staff').doc(docId).set(data, SetOptions(merge: true));
    final entity = EmployeeEntity()
      ..id = employee.id
      ..name = data['name'] as String
      ..role = data['role'] as String
      ..phone = data['phone'] as String
      ..email = data['email'] as String
      ..joinDate = (data['joinDate'] as Timestamp?)?.toDate() ?? employee.joinDate
      ..commission = _toDouble(data['commission'])
      ..active = data['active'] == true;
    return entity;
  }

  Future<void> delete(EmployeeEntity employee) async {
    await _firestore.collection('staff').doc(_docIdFor(employee)).delete();
  }

  EmployeeEntity _toEntity(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return EmployeeEntity()
      ..id = doc.id.hashCode
      ..name = data['name']?.toString() ?? ''
      ..role = data['role']?.toString() ?? ''
      ..phone = data['phone']?.toString() ?? ''
      ..email = data['email']?.toString() ?? ''
      ..joinDate = (data['joinDate'] as Timestamp?)?.toDate() ?? DateTime.now()
      ..commission = _toDouble(data['commission'])
      ..active = data['active'] == true;
  }

  Map<String, dynamic> _toMap(EmployeeEntity e) => {
        'name': e.name,
        'role': e.role,
        'phone': e.phone,
        'email': e.email,
        'joinDate': Timestamp.fromDate(e.joinDate),
        'commission': e.commission,
        'active': e.active,
      };

  String _docIdFor(EmployeeEntity employee) {
    if (employee.id != Isar.autoIncrement) return employee.id.toString();
    return employee.email.isNotEmpty
        ? employee.email.toLowerCase()
        : employee.name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
  }

  double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }
}

