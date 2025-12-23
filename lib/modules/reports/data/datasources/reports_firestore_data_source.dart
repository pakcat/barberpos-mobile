import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isar_community/isar.dart';

import '../entities/finance_entry_entity.dart';

class ReportsFirestoreDataSource {
  ReportsFirestoreDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Future<List<FinanceEntryEntity>> fetchAll({int limit = 200}) async {
    final snap = await _firestore
        .collection('financeEntries')
        .orderBy('date', descending: true)
        .limit(limit)
        .get();
    return snap.docs.map(_toEntity).toList();
  }

  Future<FinanceEntryEntity> upsert(FinanceEntryEntity entry) async {
    final docId = _docIdFor(entry);
    final data = _toMap(entry);
    await _firestore.collection('financeEntries').doc(docId).set(data, SetOptions(merge: true));
    final entity = FinanceEntryEntity()
      ..id = entry.id
      ..title = (data['title'] ?? '').toString()
      ..amount = _toInt(data['amount'])
      ..category = (data['category'] ?? '').toString()
      ..date = (data['date'] as Timestamp).toDate()
      ..type = _typeFromString((data['type'] ?? '').toString())
      ..staff = data['staff']?.toString()
      ..service = data['service']?.toString()
      ..note = data['notes']?.toString() ?? '';
    return entity;
  }

  Future<void> delete(FinanceEntryEntity entry) async {
    await _firestore.collection('financeEntries').doc(_docIdFor(entry)).delete();
  }

  FinanceEntryEntity _toEntity(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return FinanceEntryEntity()
      ..id = doc.id.hashCode
      ..title = data['title']?.toString() ?? ''
      ..amount = _toInt(data['amount'])
      ..category = data['category']?.toString() ?? ''
      ..date = (data['date'] as Timestamp?)?.toDate() ?? DateTime.now()
      ..type = _typeFromString(data['type']?.toString() ?? '')
      ..staff = data['staff']?.toString()
      ..service = data['service']?.toString()
      ..note = data['notes']?.toString() ?? '';
  }

  Map<String, dynamic> _toMap(FinanceEntryEntity entry) => {
        'title': entry.title,
        'amount': entry.amount,
        'category': entry.category,
        'date': Timestamp.fromDate(entry.date),
        'type': entry.type.name,
        'staff': entry.staff,
        'service': entry.service,
        'notes': entry.note,
      };

  EntryTypeEntity _typeFromString(String value) {
    switch (value.toLowerCase()) {
      case 'expense':
        return EntryTypeEntity.expense;
      default:
        return EntryTypeEntity.revenue;
    }
  }

  String _docIdFor(FinanceEntryEntity entry) {
    if (entry.id != Isar.autoIncrement) return entry.id.toString();
    return '${entry.title}-${entry.date.millisecondsSinceEpoch}'.replaceAll(RegExp(r'[^a-zA-Z0-9]+'), '-');
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

