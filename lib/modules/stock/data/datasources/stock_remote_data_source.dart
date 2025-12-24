import 'package:dio/dio.dart';

import '../entities/stock_entity.dart';

class StockRemoteDataSource {
  StockRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<StockEntity>> fetchAll() async {
    final res = await _dio.get<List<dynamic>>('/stock');
    final data = res.data ?? const [];
    return data.whereType<Map>().map((raw) {
      return _toEntity(Map<String, dynamic>.from(raw));
    }).toList();
  }

  Future<StockEntity> adjust({
    required int stockId,
    required int change,
    required String type,
    String? note,
    int? productId,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/stock/adjust',
      data: {
        'stockId': stockId,
        'change': change,
        'type': type,
        'note': note,
        'productId': productId,
      },
    );
    final data = res.data ?? <String, dynamic>{};
    final entity = StockEntity()
      ..name = ''
      ..category = ''
      ..image = ''
      ..stock = int.tryParse(data['stock']?.toString() ?? '') ?? 0
      ..transactions = int.tryParse(data['transactions']?.toString() ?? '') ?? 0;
    entity.id = stockId;
    return entity;
  }

  Future<List<Map<String, dynamic>>> history(int stockId, {int limit = 50}) async {
    final res = await _dio.get<List<dynamic>>('/stock/$stockId/history', queryParameters: {'limit': limit});
    final data = res.data ?? const [];
    return data.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  StockEntity _toEntity(Map<String, dynamic> raw) {
    final entity = StockEntity()
      ..name = raw['name']?.toString() ?? ''
      ..category = raw['category']?.toString() ?? ''
      ..image = raw['image']?.toString() ?? ''
      ..stock = int.tryParse(raw['stock']?.toString() ?? '') ?? 0
      ..transactions = int.tryParse(raw['transactions']?.toString() ?? '') ?? 0;
    entity.id = int.tryParse(raw['id']?.toString() ?? '') ?? 0;
    return entity;
  }
}
