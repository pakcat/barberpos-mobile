import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../entities/finance_entry_entity.dart';

class FinanceRemoteDataSource {
  FinanceRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<FinanceEntryEntity>> fetchAll({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final params = <String, dynamic>{};
    if (startDate != null) {
      params['startDate'] = _formatDate(startDate);
    }
    if (endDate != null) {
      params['endDate'] = _formatDate(endDate);
    }
    final res = await _dio.get<List<dynamic>>(
      '/finance',
      queryParameters: params.isEmpty ? null : params,
    );
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

  Future<Uint8List> downloadExport({
    required String format,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final params = <String, dynamic>{'format': format};
    if (startDate != null) {
      params['startDate'] = _formatDate(startDate);
    }
    if (endDate != null) {
      params['endDate'] = _formatDate(endDate);
    }
    final res = await _dio.get<List<int>>(
      '/finance/export',
      queryParameters: params,
      options: Options(responseType: ResponseType.bytes),
    );
    return Uint8List.fromList(res.data ?? const <int>[]);
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

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
