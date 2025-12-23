import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:isar_community/isar.dart';

import '../entities/category_entity.dart';

class CategoryFirestoreDataSource {
  CategoryFirestoreDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Future<List<CategoryEntity>> fetchAll({int limit = 200}) async {
    final snap = await _firestore.collection('categories').orderBy('name').limit(limit).get();
    return snap.docs.map(_toEntity).toList();
  }

  Future<CategoryEntity> upsert(CategoryEntity category) async {
    final docId = _docIdFor(category);
    await _firestore.collection('categories').doc(docId).set({'name': category.name});
    return category;
  }

  Future<void> delete(CategoryEntity category) async {
    await _firestore.collection('categories').doc(_docIdFor(category)).delete();
  }

  CategoryEntity _toEntity(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return CategoryEntity()
      ..id = doc.id.hashCode
      ..name = data['name']?.toString() ?? '';
  }

  String _docIdFor(CategoryEntity category) {
    if (category.id != Isar.autoIncrement) return category.id.toString();
    return category.name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
  }
}

