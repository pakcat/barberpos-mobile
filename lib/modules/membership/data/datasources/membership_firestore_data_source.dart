import 'package:cloud_firestore/cloud_firestore.dart';

import '../entities/membership_topup_entity.dart';

class MembershipFirestoreDataSource {
  MembershipFirestoreDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Future<List<MembershipTopupEntity>> fetchTopups({int limit = 200}) async {
    final snap = await _firestore.collection('membershipTopups').orderBy('date', descending: true).limit(limit).get();
    return snap.docs.map(_toTopup).toList();
  }

  Future<int> fetchUsedQuota() async {
    final doc = await _firestore.collection('membershipState').doc('state').get();
    final data = doc.data();
    return _toInt(data?['usedQuota']);
  }

  Future<MembershipTopupEntity> addTopup(MembershipTopupEntity topup) async {
    final data = _toMap(topup);
    await _firestore.collection('membershipTopups').add(data);
    return topup;
  }

  Future<void> setUsedQuota(int value) async {
    await _firestore.collection('membershipState').doc('state').set({'usedQuota': value}, SetOptions(merge: true));
  }

  MembershipTopupEntity _toTopup(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return MembershipTopupEntity()
      ..id = doc.id.hashCode
      ..amount = _toInt(data['amount'])
      ..manager = data['manager']?.toString() ?? ''
      ..note = data['note']?.toString() ?? ''
      ..date = (data['date'] as Timestamp?)?.toDate() ?? DateTime.now();
  }

  Map<String, dynamic> _toMap(MembershipTopupEntity topup) => {
        'amount': topup.amount,
        'manager': topup.manager,
        'note': topup.note,
        'date': Timestamp.fromDate(topup.date),
      };

  int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
