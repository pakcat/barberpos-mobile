import 'package:dio/dio.dart';

import '../models/dashboard_models.dart';

class DashboardRemoteDataSource {
  DashboardRemoteDataSource(this._dio);

  final Dio _dio;

  Future<DashboardSummaryDto> fetchSummary() async {
    final res = await _dio.get<Map<String, dynamic>>('/dashboard/summary');
    return DashboardSummaryDto.fromJson(res.data ?? <String, dynamic>{});
  }

  Future<List<DashboardItemDto>> fetchTopServices() async {
    final res = await _dio.get<List<dynamic>>('/dashboard/top-services');
    return _toItems(res.data);
  }

  Future<List<DashboardItemDto>> fetchTopStaff() async {
    final res = await _dio.get<List<dynamic>>('/dashboard/top-staff');
    return _toItems(res.data);
  }

  Future<List<SalesPointDto>> fetchSalesSeries({required String range}) async {
    final res = await _dio.get<List<dynamic>>(
      '/dashboard/sales',
      queryParameters: {'range': range},
    );
    return _toPoints(res.data);
  }

  List<DashboardItemDto> _toItems(List<dynamic>? data) {
    return (data ?? [])
        .whereType<Map>()
        .map((e) => DashboardItemDto.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  List<SalesPointDto> _toPoints(List<dynamic>? data) {
    return (data ?? [])
        .whereType<Map>()
        .map((e) => SalesPointDto.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }
}
