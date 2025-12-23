import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isar_community/isar.dart';

import '../entities/product_entity.dart';

class ProductFirestoreDataSource {
  ProductFirestoreDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Future<List<ProductEntity>> fetchAll() async {
    final snap = await _firestore.collection('products').get();
    final result = <ProductEntity>[];
    for (final doc in snap.docs) {
      final entity = _toEntity(doc);
      result.add(entity);
      // Backfill localId so future updates reuse the same document
      final data = doc.data();
      if (data['localId'] == null) {
        await doc.reference.set({'localId': entity.id}, SetOptions(merge: true));
      }
    }
    return result;
  }

  Future<ProductEntity> upsert(ProductEntity product) async {
    final existingDocId = await _findDocId(product.id);
    final docId = existingDocId ?? _docIdFor(product);
    final data = _toMap(product);
    await _firestore.collection('products').doc(docId).set(data, SetOptions(merge: true));
    final entity = ProductEntity()
      ..id = product.id
      ..name = data['name'] as String
      ..category = data['category'] as String
      ..price = data['price'] as int
      ..image = data['image'] as String
      ..trackStock = data['trackStock'] as bool
      ..stock = data['stock'] as int
      ..minStock = data['minStock'] as int;
    return entity;
  }

  Future<void> delete(ProductEntity product) async {
    final existingDocId = await _findDocId(product.id);
    final docId = existingDocId ?? _docIdFor(product);
    await _firestore.collection('products').doc(docId).delete();
  }

  ProductEntity _toEntity(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final localId = _toInt(data['localId']) == 0 ? _toInt(data['id']) : _toInt(data['localId']);
    return ProductEntity()
      ..id = localId == 0 ? _stableId(doc.id) : localId
      ..name = data['name']?.toString() ?? ''
      ..category = data['category']?.toString() ?? ''
      ..price = _toInt(data['price'])
      ..image = data['image']?.toString() ?? ''
      ..trackStock = data['trackStock'] == true
      ..stock = _toInt(data['stock'])
      ..minStock = _toInt(data['minStock']);
  }

  Map<String, dynamic> _toMap(ProductEntity product) => {
        'name': product.name,
        'category': product.category,
        'price': product.price,
        'image': product.image,
        'trackStock': product.trackStock,
        'stock': product.stock,
        'minStock': product.minStock,
        'localId': product.id,
      };

  String _docIdFor(ProductEntity product) {
    if (product.id != Isar.autoIncrement) return product.id.toString();
    return product.name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
  }

  Future<String?> _findDocId(Id localId) async {
    final query = await _firestore
        .collection('products')
        .where('localId', isEqualTo: localId)
        .limit(1)
        .get();
    if (query.docs.isEmpty) return null;
    return query.docs.first.id;
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  int _stableId(String value) {
    // Stable deterministic hash for Firestore string ids
    var hash = 0;
    for (final code in value.codeUnits) {
      hash = (hash * 31 + code) & 0x7fffffff;
    }
    return hash;
  }
}

