import 'package:isar_community/isar.dart';

import '../entities/category_entity.dart';
import '../entities/customer_entity.dart';

class CategoryDto {
  CategoryDto({required this.id, required this.name});

  final String id;
  final String name;

  factory CategoryDto.fromJson(Map<String, dynamic> json) {
    return CategoryDto(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  CategoryEntity toEntity() {
    final entity = CategoryEntity()..name = name;
    entity.id = int.tryParse(id) ?? Isar.autoIncrement;
    return entity;
  }
}

class CustomerDto {
  CustomerDto({
    required this.id,
    required this.name,
    required this.phone,
    this.email = '',
    this.address = '',
  });

  final String id;
  final String name;
  final String phone;
  final String email;
  final String address;

  factory CustomerDto.fromJson(Map<String, dynamic> json) {
    return CustomerDto(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
    );
  }

  CustomerEntity toEntity() {
    final entity = CustomerEntity()
      ..name = name
      ..phone = phone
      ..email = email
      ..address = address;
    entity.id = int.tryParse(id) ?? Isar.autoIncrement;
    return entity;
  }
}

