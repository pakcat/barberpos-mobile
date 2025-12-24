import 'package:dio/dio.dart';

import '../entities/closing_history_entity.dart';

class ClosingSummaryDto {
  ClosingSummaryDto({
    this.totalCash = 0,
    this.totalNonCash = 0,
    this.totalCard = 0,
  });

  final int totalCash;
  final int totalNonCash;
  final int totalCard;

  factory ClosingSummaryDto.fromJson(Map<String, dynamic> json) {
    return ClosingSummaryDto(
      totalCash: int.tryParse(json['totalCash']?.toString() ?? '') ??
          int.tryParse(json['cash']?.toString() ?? '') ??
          0,
      totalNonCash: int.tryParse(json['totalNonCash']?.toString() ?? '') ??
          int.tryParse(json['nonCash']?.toString() ?? '') ??
          0,
      totalCard: int.tryParse(json['totalCard']?.toString() ?? '') ??
          int.tryParse(json['card']?.toString() ?? '') ??
          0,
    );
  }
}

class ClosingRemoteDataSource {
  ClosingRemoteDataSource(this._dio);

  final Dio _dio;

  Future<ClosingSummaryDto> fetchSummary() async {
    final res = await _dio.get<Map<String, dynamic>>('/closing/summary');
    return ClosingSummaryDto.fromJson(res.data ?? <String, dynamic>{});
  }

  Future<List<ClosingHistoryEntity>> fetchHistory({int limit = 50}) async {
    final res = await _dio.get<List<dynamic>>(
      '/closing',
      queryParameters: {'limit': limit},
    );
    final data = res.data ?? const [];
    return data.whereType<Map>().map((raw) {
      final json = Map<String, dynamic>.from(raw);
      final entity = ClosingHistoryEntity()
        ..tanggal = _parseDate(json['tanggal'])
        ..shift = json['shift']?.toString() ?? ''
        ..karyawan = json['karyawan']?.toString() ?? ''
        ..shiftId = json['shiftId']?.toString()
        ..operatorName = json['operatorName']?.toString() ?? ''
        ..total = int.tryParse(json['total']?.toString() ?? '') ?? 0
        ..status = json['status']?.toString() ?? ''
        ..catatan = json['catatan']?.toString() ?? ''
        ..fisik = json['fisik']?.toString() ?? '';
      entity.id = int.tryParse(json['id']?.toString() ?? '') ?? 0;
      return entity;
    }).toList();
  }

  Future<void> submitClosing(Map<String, dynamic> payload) {
    return _dio.post('/closing', data: payload);
  }

  DateTime _parseDate(dynamic raw) {
    final s = raw?.toString() ?? '';
    final parsed = DateTime.tryParse(s);
    if (parsed != null) return parsed;
    // If API returns "YYYY-MM-DD", DateTime.tryParse already handles it, but keep safe.
    return DateTime.now();
  }
}
