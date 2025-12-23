import 'package:dio/dio.dart';

import '../entities/finance_entry_entity.dart';

class FinanceRemoteDataSource {
  FinanceRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<FinanceEntryEntity>> fetchAll() async {
    final res = await _dio.get<List<dynamic>>('/finance');
    final data = res.data ?? const [];
    return data.map(_toEntity).toList();
  }

  Future<FinanceEntryEntity> add(FinanceEntryEntity entry) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/finance',
      data: {
        'title': entry.title,
        'amount': entry.amount,
        'category': entry.category,
        'date': entry.date.toIso8601String().split('T').first,
        'type': entry.type.name,
        'note': entry.note,
        'staff': entry.staff,
        'service': entry.service,
      },
    );
    final data = res.data ?? <String, dynamic>{};
    return _toEntity(data);
  }

  FinanceEntryEntity _toEntity(dynamic raw) {
    final e = FinanceEntryEntity()
      ..title = raw['title']?.toString() ?? ''
      ..amount = int.tryParse(raw['amount']?.toString() ?? '') ?? 0
      ..category = raw['category']?.toString() ?? ''
      ..date = DateTime.tryParse(raw['date']?.toString() ?? '') ?? DateTime.now()
      ..type = _typeFromString(raw['type']?.toString() ?? '')
      ..note = raw['note']?.toString() ?? ''
      ..staff = raw['staff']?.toString() ?? ''
      ..service = raw['service']?.toString() ?? '';
    e.id = int.tryParse(raw['id']?.toString() ?? '') ?? 0;
    return e;
  }

  EntryTypeEntity _typeFromString(String v) {
    return v.toLowerCase() == 'expense' ? EntryTypeEntity.expense : EntryTypeEntity.revenue;
  }
}
