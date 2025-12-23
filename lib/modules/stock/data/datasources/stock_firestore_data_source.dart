import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isar_community/isar.dart';

import '../entities/stock_entity.dart';

class StockFirestoreDataSource {
  StockFirestoreDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Future<List<StockEntity>> fetchAll({int limit = 500}) async {
    final snap = await _firestore.collection('stock').orderBy('name').limit(limit).get();
    return snap.docs.map(_toEntity).toList();
  }

  Future<StockEntity> upsert(StockEntity stock) async {
    final docId = _docIdFor(stock);
    final data = _toMap(stock);
    await _firestore.collection('stock').doc(docId).set(data, SetOptions(merge: true));
    final entity = StockEntity()
      ..id = stock.id
      ..name = data['name'] as String
      ..category = data['category'] as String
      ..image = data['image'] as String
      ..stock = data['stock'] as int
      ..transactions = data['transactions'] as int;
    return entity;
  }

  Future<void> delete(StockEntity stock) async {
    await _firestore.collection('stock').doc(_docIdFor(stock)).delete();
  }

  StockEntity _toEntity(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return StockEntity()
      ..id = doc.id.hashCode
      ..name = data['name']?.toString() ?? ''
      ..category = data['category']?.toString() ?? ''
      ..image = data['image']?.toString() ?? ''
      ..stock = _toInt(data['stock'])
      ..transactions = _toInt(data['transactions']);
  }

  Map<String, dynamic> _toMap(StockEntity stock) => {
        'name': stock.name,
        'category': stock.category,
        'image': stock.image,
        'stock': stock.stock,
        'transactions': stock.transactions,
      };

  String _docIdFor(StockEntity stock) {
    if (stock.id != Isar.autoIncrement) return stock.id.toString();
    return stock.name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

