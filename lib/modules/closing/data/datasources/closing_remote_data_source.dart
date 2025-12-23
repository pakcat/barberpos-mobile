import 'package:dio/dio.dart';

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

  Future<void> submitClosing(Map<String, dynamic> payload) {
    return _dio.post('/closing', data: payload);
  }
}
