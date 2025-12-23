import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/dashboard_models.dart';

class DashboardFirestoreDataSource {
  DashboardFirestoreDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Future<DashboardSummaryDto> fetchSummary() async {
    final doc = await _firestore.collection('dashboard').doc('summary').get();
    return DashboardSummaryDto.fromJson(doc.data() ?? <String, dynamic>{});
  }

  Future<List<DashboardItemDto>> fetchTopServices() async {
    final snap = await _firestore.collection('dashboard_topServices').orderBy('qty', descending: true).limit(10).get();
    return snap.docs.map((d) => DashboardItemDto.fromJson(d.data())).toList();
  }

  Future<List<DashboardItemDto>> fetchTopStaff() async {
    final snap = await _firestore.collection('dashboard_topStaff').orderBy('amount', descending: true).limit(10).get();
    return snap.docs.map((d) => DashboardItemDto.fromJson(d.data())).toList();
  }

  Future<List<SalesPointDto>> fetchSalesSeries({required String range}) async {
    final doc = await _firestore.collection('dashboard_sales').doc(range.toLowerCase()).get();
    final data = doc.data()?['points'] as List<dynamic>? ?? [];
    return data
        .whereType<Map>()
        .map((e) => SalesPointDto.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
