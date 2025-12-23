import 'package:cloud_firestore/cloud_firestore.dart';

import 'closing_remote_data_source.dart';
import '../entities/closing_history_entity.dart';

class ClosingFirestoreDataSource {
  ClosingFirestoreDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Future<ClosingSummaryDto> fetchSummary() async {
    final snapshot = await _firestore
        .collection('closings')
        .orderBy('tanggal', descending: true)
        .limit(50)
        .get();
    int cash = 0;
    int nonCash = 0;
    int card = 0;
    for (final doc in snapshot.docs) {
      final data = doc.data();
      cash += _toInt(data['totalCash'] ?? data['cash']);
      nonCash += _toInt(data['totalNonCash'] ?? data['nonCash']);
      card += _toInt(data['totalCard'] ?? data['card']);
    }
    return ClosingSummaryDto(totalCash: cash, totalNonCash: nonCash, totalCard: card);
  }

  Future<List<ClosingHistoryEntity>> fetchHistory({int limit = 100}) async {
    final snapshot = await _firestore
        .collection('closings')
        .orderBy('tanggal', descending: true)
        .limit(limit)
        .get();
    return snapshot.docs.map(_toEntity).toList();
  }

  Future<void> submitClosing(Map<String, dynamic> payload) async {
    await _firestore.collection('closings').add({
      ...payload,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  ClosingHistoryEntity _toEntity(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return ClosingHistoryEntity()
      ..id = doc.id.hashCode
      ..tanggal = DateTime.tryParse(data['tanggal']?.toString() ?? '') ?? DateTime.now()
      ..shift = data['shift']?.toString() ?? 'Shift'
      ..karyawan = data['karyawan']?.toString() ?? 'Karyawan'
      ..operatorName = data['operator']?.toString() ?? data['operatorName']?.toString() ?? ''
      ..shiftId = data['shiftId']?.toString()
      ..total = _toInt(data['total'] ?? data['totalCash'] ?? 0)
      ..status = data['status']?.toString() ?? 'Selesai'
      ..catatan = data['catatan']?.toString() ?? ''
      ..fisik = data['fisik']?.toString() ?? '';
  }

  int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
