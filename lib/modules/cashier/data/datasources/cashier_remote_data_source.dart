import 'package:dio/dio.dart';

import '../models/order_dtos.dart';
import '../../presentation/models/cashier_item.dart';

class CashierRemoteDataSource {
  CashierRemoteDataSource(this._dio);

  final Dio _dio;

  Future<OrderResponseDto> submitOrder(OrderPayloadDto payload) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/orders',
      data: payload.toJson(),
      options: Options(headers: {'X-Idempotency-Key': payload.clientRef}),
    );
    return OrderResponseDto.fromJson(res.data ?? <String, dynamic>{});
  }

  Future<List<ServiceItem>> fetchServices() async {
    final res = await _dio.get<List<dynamic>>('/services');
    final data = res.data ?? const [];
    return data
        .whereType<Map>()
        .map((raw) => Map<String, dynamic>.from(raw))
        .map(
          (raw) => ServiceItem(
            id: raw['id']?.toString() ?? '',
            name: raw['name']?.toString() ?? '',
            category: raw['category']?.toString() ?? 'Lainnya',
            price: raw['price']?.toString() ?? '0',
            image: raw['image']?.toString() ?? '',
          ),
        )
        .toList();
  }
}
