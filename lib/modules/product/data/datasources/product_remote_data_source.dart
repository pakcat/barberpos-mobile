import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:typed_data';

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
        .map(
          (json) =>
              ProductDto.fromJson(Map<String, dynamic>.from(json)).toEntity(),
        )
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
    final hasCandidateId = product.id > 0 && product.id < 1000000000;
    if (hasCandidateId) {
      payload['id'] = product.id;
    }
    Response<Map<String, dynamic>> res;
    try {
      res = await _dio.post<Map<String, dynamic>>('/products', data: payload);
    } on DioException catch (e) {
      // If we accidentally sent a local ID, backend treats it as update and returns 404.
      // Retry as create without ID.
      if (e.response?.statusCode == 404 && hasCandidateId) {
        payload.remove('id');
        res = await _dio.post<Map<String, dynamic>>('/products', data: payload);
      } else {
        rethrow;
      }
    }
    final data = res.data;
    if (data == null) {
      return ProductDto.fromJson(const <String, dynamic>{}).toEntity();
    }
    return ProductDto.fromJson(Map<String, dynamic>.from(data)).toEntity();
  }

  Future<void> delete(int id) async {
    await _dio.delete<void>('/products/$id');
  }

  Future<String?> uploadImage({
    required int productId,
    required Uint8List bytes,
    required String filename,
    required String mimeType,
  }) async {
    final form = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        bytes,
        filename: filename,
        contentType: MediaType.parse(mimeType),
      ),
    });
    final res = await _dio.post<Map<String, dynamic>>(
      '/products/$productId/image',
      data: form,
      options: Options(
        sendTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 60),
      ),
    );
    final data = res.data;
    if (data == null) return null;
    return data['image']?.toString();
  }
}
