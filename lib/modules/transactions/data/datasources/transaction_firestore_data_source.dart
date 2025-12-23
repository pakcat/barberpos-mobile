import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isar_community/isar.dart';

import '../entities/transaction_entity.dart';

class TransactionFirestoreDataSource {
  TransactionFirestoreDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Future<List<TransactionEntity>> fetchAll({int limit = 200}) async {
    final snap = await _firestore
        .collection('transactions')
        .orderBy('date', descending: true)
        .limit(limit)
        .get();
    return snap.docs.map(_toEntity).toList();
  }

  Future<TransactionEntity> upsert(TransactionEntity tx) async {
    final docId = _docIdFor(tx);
    final data = _toMap(tx);
    await _firestore.collection('transactions').doc(docId).set(data, SetOptions(merge: true));
    final entity = TransactionEntity()
      ..id = tx.id
      ..code = data['code'] as String
      ..date = (data['date'] as Timestamp).toDate()
      ..time = data['time'] as String
      ..amount = data['amount'] as int
      ..paymentMethod = data['paymentMethod'] as String
      ..stylist = data['stylist']?.toString() ?? ''
      ..status = _statusFromString(data['status'] as String)
      ..items = tx.items
      ..customer = tx.customer;
    return entity;
  }

  Future<void> delete(TransactionEntity tx) async {
    final docId = _docIdFor(tx);
    await _firestore.collection('transactions').doc(docId).delete();
  }

  TransactionEntity _toEntity(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return TransactionEntity()
      ..id = doc.id.hashCode
      ..code = data['code']?.toString() ?? ''
      ..date = (data['date'] as Timestamp?)?.toDate() ?? DateTime.now()
      ..time = data['time']?.toString() ?? ''
      ..amount = _toInt(data['amount'])
      ..paymentMethod = data['paymentMethod']?.toString() ?? ''
      ..stylist = data['stylist']?.toString() ?? ''
      ..status = _statusFromString(data['status']?.toString() ?? '')
      ..items = _mapItems(data['items'])
      ..customer = _mapCustomer(data['customer']);
  }

  Map<String, dynamic> _toMap(TransactionEntity tx) {
    return {
      'code': tx.code,
      'date': Timestamp.fromDate(tx.date),
      'time': tx.time,
      'amount': tx.amount,
      'paymentMethod': tx.paymentMethod,
      'stylist': tx.stylist,
      'status': tx.status.name,
      'items': tx.items
          .map((i) => {'name': i.name, 'category': i.category, 'price': i.price, 'qty': i.qty})
          .toList(),
      'customer': tx.customer == null
          ? null
          : {
              'name': tx.customer!.name,
              'phone': tx.customer!.phone,
              'email': tx.customer!.email,
              'address': tx.customer!.address,
              'visits': tx.customer!.visits,
              'lastVisit': tx.customer!.lastVisit,
            },
    };
  }

  List<TransactionLineEntity> _mapItems(dynamic items) {
    if (items is! Iterable) return [];
    return items
        .map(
          (raw) => TransactionLineEntity()
            ..name = raw['name']?.toString() ?? ''
            ..category = raw['category']?.toString() ?? ''
            ..price = _toInt(raw['price'])
            ..qty = _toInt(raw['qty']),
        )
        .toList();
  }

  TransactionCustomerEntity? _mapCustomer(dynamic customer) {
    if (customer == null) return null;
    return TransactionCustomerEntity()
      ..name = customer['name']?.toString() ?? ''
      ..phone = customer['phone']?.toString() ?? ''
      ..email = customer['email']?.toString() ?? ''
      ..address = customer['address']?.toString() ?? ''
      ..visits = _toInt(customer['visits'])
      ..lastVisit = customer['lastVisit']?.toString() ?? '';
  }

  TransactionStatusEntity _statusFromString(String value) {
    return value.toLowerCase() == 'refund' ? TransactionStatusEntity.refund : TransactionStatusEntity.paid;
  }

  String _docIdFor(TransactionEntity tx) {
    if (tx.id != Isar.autoIncrement) return tx.id.toString();
    if (tx.code.isNotEmpty) return tx.code.replaceAll('#', '');
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

