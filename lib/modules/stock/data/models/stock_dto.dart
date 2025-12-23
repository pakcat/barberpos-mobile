import 'package:isar_community/isar.dart';

import '../entities/stock_entity.dart';

class StockDto {
  StockDto({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.stock,
    this.transactions = 0,
  });

  final String id;
  final String name;
  final String category;
  final String image;
  final int stock;
  final int transactions;

  factory StockDto.fromJson(Map<String, dynamic> json) {
    return StockDto(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      stock: int.tryParse(json['stock']?.toString() ?? '') ?? 0,
      transactions: int.tryParse(json['transactions']?.toString() ?? '') ?? 0,
    );
  }

  StockEntity toEntity() {
    final entity = StockEntity()
      ..name = name
      ..category = category
      ..image = image
      ..stock = stock
      ..transactions = transactions;
    entity.id = int.tryParse(id) ?? Isar.autoIncrement;
    return entity;
  }
}

