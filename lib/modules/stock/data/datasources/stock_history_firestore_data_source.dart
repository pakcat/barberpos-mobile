import 'package:cloud_firestore/cloud_firestore.dart';

class StockHistoryFirestoreDataSource {
  StockHistoryFirestoreDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Future<void> appendHistory({
    required int productId,
    required int change,
    required int remaining,
    required String type,
    String? note,
  }) async {
    final docRef = await _findProductDoc(productId);
    if (docRef == null) return;
    await docRef.collection('stockHistory').add({
      'change': change,
      'remaining': remaining,
      'type': type,
      'note': note ?? '',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<StockHistoryDto>> fetchHistory({
    required int productId,
    int limit = 50,
  }) async {
    final docRef = await _findProductDoc(productId);
    if (docRef == null) return [];
    final snap = await docRef
        .collection('stockHistory')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();
    return snap.docs.map((d) => StockHistoryDto.fromJson(d.data())).toList();
  }

  Future<DocumentReference<Map<String, dynamic>>?> _findProductDoc(int localId) async {
    final query = await _firestore
        .collection('products')
        .where('localId', isEqualTo: localId)
        .limit(1)
        .get();
    if (query.docs.isNotEmpty) return query.docs.first.reference;
    // fallback: try by document id string
    final doc = await _firestore.collection('products').doc(localId.toString()).get();
    if (doc.exists) return doc.reference;
    return null;
  }
}

class StockHistoryDto {
  StockHistoryDto({
    required this.change,
    required this.remaining,
    required this.type,
    required this.createdAt,
  });

  final int change;
  final int remaining;
  final String type;
  final DateTime createdAt;

  factory StockHistoryDto.fromJson(Map<String, dynamic> json) {
    return StockHistoryDto(
      change: _toInt(json['change']),
      remaining: _toInt(json['remaining']),
      type: json['type']?.toString() ?? 'recount',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
