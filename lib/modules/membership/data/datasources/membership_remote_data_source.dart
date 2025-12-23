import 'package:dio/dio.dart';

import '../entities/membership_topup_entity.dart';

class MembershipRemoteDataSource {
  MembershipRemoteDataSource(this._dio);

  final Dio _dio;

  Future<int> fetchUsedQuota() async {
    final res = await _dio.get<Map<String, dynamic>>('/membership');
    return int.tryParse(res.data?['usedQuota']?.toString() ?? '') ?? 0;
  }

  Future<void> setUsedQuota(int value) async {
    await _dio.put('/membership', data: {'usedQuota': value});
  }

  Future<List<MembershipTopupEntity>> fetchTopups() async {
    final res = await _dio.get<List<dynamic>>('/membership/topups');
    final data = res.data ?? const [];
    return data.map((raw) {
      final e = MembershipTopupEntity()
        ..amount = int.tryParse(raw['amount']?.toString() ?? '') ?? 0
        ..manager = raw['manager']?.toString() ?? ''
        ..note = raw['note']?.toString() ?? ''
        ..date = DateTime.tryParse(raw['date']?.toString() ?? '') ?? DateTime.now();
      e.id = int.tryParse(raw['id']?.toString() ?? '') ?? 0;
      return e;
    }).toList();
  }

  Future<MembershipTopupEntity> addTopup(MembershipTopupEntity topup) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/membership/topups',
      data: {
        'amount': topup.amount,
        'manager': topup.manager,
        'note': topup.note,
        'date': topup.date.toIso8601String(),
      },
    );
    final data = res.data ?? <String, dynamic>{};
    final e = MembershipTopupEntity()
      ..amount = int.tryParse(data['amount']?.toString() ?? '') ?? topup.amount
      ..manager = data['manager']?.toString() ?? topup.manager
      ..note = data['note']?.toString() ?? topup.note
      ..date = DateTime.tryParse(data['date']?.toString() ?? '') ?? topup.date;
    e.id = int.tryParse(data['id']?.toString() ?? '') ?? topup.id;
    return e;
  }
}
