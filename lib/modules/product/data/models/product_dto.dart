import 'package:isar_community/isar.dart';

import '../entities/product_entity.dart';

class ProductDto {
  ProductDto({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.image = '',
    this.trackStock = false,
    this.stock = 0,
    this.minStock = 0,
  });

  final String id;
  final String name;
  final String category;
  final int price;
  final String image;
  final bool trackStock;
  final int stock;
  final int minStock;

  factory ProductDto.fromJson(Map<String, dynamic> json) {
    return ProductDto(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      price: int.tryParse(json['price']?.toString() ?? '') ?? 0,
      image: json['image']?.toString() ?? '',
      trackStock: json['trackStock'] == true,
      stock: int.tryParse(json['stock']?.toString() ?? '') ?? 0,
      minStock: int.tryParse(json['minStock']?.toString() ?? '') ?? 0,
    );
  }

  ProductEntity toEntity() {
    final entity = ProductEntity()
      ..name = name
      ..category = category
      ..price = price
      ..image = image
      ..trackStock = trackStock
      ..stock = stock
      ..minStock = minStock;
    entity.id = int.tryParse(id) ?? Isar.autoIncrement;
    return entity;
  }
}

