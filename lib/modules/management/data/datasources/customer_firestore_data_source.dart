import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isar_community/isar.dart';

import '../entities/customer_entity.dart';

class CustomerFirestoreDataSource {
  CustomerFirestoreDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Future<List<CustomerEntity>> fetchAll({int limit = 500}) async {
    final snap = await _firestore.collection('customers').orderBy('name').limit(limit).get();
    return snap.docs.map(_toEntity).toList();
  }

  Future<CustomerEntity> upsert(CustomerEntity customer) async {
    final docId = _docIdFor(customer);
    final data = _toMap(customer);
    await _firestore.collection('customers').doc(docId).set(data, SetOptions(merge: true));
    final entity = CustomerEntity()
      ..id = customer.id
      ..name = data['name'] as String
      ..phone = data['phone'] as String
      ..email = data['email'] as String
      ..address = data['address'] as String;
    return entity;
  }

  Future<void> delete(CustomerEntity customer) async {
    final docId = _docIdFor(customer);
    await _firestore.collection('customers').doc(docId).delete();
  }

  CustomerEntity _toEntity(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return CustomerEntity()
      ..id = doc.id.hashCode
      ..name = data['name']?.toString() ?? ''
      ..phone = data['phone']?.toString() ?? ''
      ..email = data['email']?.toString() ?? ''
      ..address = data['address']?.toString() ?? '';
  }

  Map<String, dynamic> _toMap(CustomerEntity customer) => {
        'name': customer.name,
        'phone': customer.phone,
        'email': customer.email,
        'address': customer.address,
      };

  String _docIdFor(CustomerEntity customer) {
    if (customer.id != Isar.autoIncrement) return customer.id.toString();
    return customer.email.isNotEmpty
        ? customer.email.toLowerCase()
        : customer.name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
  }
}

