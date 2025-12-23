import 'package:isar_community/isar.dart';

import '../entities/employee_entity.dart';

class EmployeeDto {
  EmployeeDto({
    required this.id,
    required this.name,
    required this.role,
    required this.phone,
    required this.email,
    required this.joinDate,
    this.commission,
    this.active = true,
  });

  final String id;
  final String name;
  final String role;
  final String phone;
  final String email;
  final DateTime joinDate;
  final double? commission;
  final bool active;

  factory EmployeeDto.fromJson(Map<String, dynamic> json) {
    return EmployeeDto(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      joinDate: DateTime.tryParse(json['joinDate']?.toString() ?? '') ?? DateTime.now(),
      commission: json['commission'] != null ? double.tryParse(json['commission'].toString()) : null,
      active: json['active'] != false,
    );
  }

  EmployeeEntity toEntity() {
    final entity = EmployeeEntity()
      ..name = name
      ..role = role
      ..phone = phone
      ..email = email
      ..joinDate = joinDate
      ..commission = commission
      ..active = active;
    entity.id = int.tryParse(id) ?? Isar.autoIncrement;
    return entity;
  }
}

