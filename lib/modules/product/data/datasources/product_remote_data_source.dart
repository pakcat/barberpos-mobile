import 'package:dio/dio.dart';

import '../entities/product_entity.dart';

class ProductRemoteDataSource {
  ProductRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<ProductEntity>> fetchAll() async {
    final res = await _dio.get<List<dynamic>>('/products');
    final data = res.data ?? [];
    return data.map<ProductEntity>((json) {
      return ProductEntity()
        ..id = int.tryParse(json['id']?.toString() ?? '') ?? ProductEntity().id
        ..name = json['name']?.toString() ?? ''
        ..category = json['category']?.toString() ?? ''
        ..price = int.tryParse(json['price']?.toString() ?? '') ?? 0
        ..image = json['image']?.toString() ?? ''
        ..trackStock = json['trackStock'] == true
        ..stock = int.tryParse(json['stock']?.toString() ?? '') ?? 0
        ..minStock = int.tryParse(json['minStock']?.toString() ?? '') ?? 0;
    }).toList();
  }
}
