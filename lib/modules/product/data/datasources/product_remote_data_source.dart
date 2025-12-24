import 'package:dio/dio.dart';

import '../models/product_dto.dart';
import '../entities/product_entity.dart';

class ProductRemoteDataSource {
  ProductRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<ProductEntity>> fetchAll() async {
    final res = await _dio.get<List<dynamic>>('/products');
    final data = res.data ?? [];
    return data
        .whereType<Map>()
        .map((json) => ProductDto.fromJson(Map<String, dynamic>.from(json)).toEntity())
        .toList();
  }

  Future<ProductEntity> upsert(ProductEntity product) async {
    final payload = <String, dynamic>{
      'name': product.name,
      'category': product.category,
      'price': product.price,
      'image': product.image,
      'trackStock': product.trackStock,
      'stock': product.stock,
      'minStock': product.minStock,
    };
    // Only send ID if it looks like a server ID (small positive int).
    // Local/temp IDs may be hash codes which can collide with server sequences.
    if (product.id > 0 && product.id < 1000000000) {
      payload['id'] = product.id;
    }
    final res = await _dio.post<Map<String, dynamic>>('/products', data: payload);
    final data = res.data;
    if (data == null) return ProductDto.fromJson(const <String, dynamic>{}).toEntity();
    return ProductDto.fromJson(Map<String, dynamic>.from(data)).toEntity();
  }

  Future<void> delete(int id) async {
    await _dio.delete<void>('/products/$id');
  }
}
