import 'package:isar_community/isar.dart';

import '../entities/finance_entry_entity.dart';

class FinanceEntryDto {
  FinanceEntryDto({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.type,
    this.note = '',
    this.staff,
    this.service,
  });

  final String id;
  final String title;
  final int amount;
  final String category;
  final DateTime date;
  final String type;
  final String note;
  final String? staff;
  final String? service;

  factory FinanceEntryDto.fromJson(Map<String, dynamic> json) {
    return FinanceEntryDto(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      amount: int.tryParse(json['amount']?.toString() ?? '') ?? 0,
      category: json['category']?.toString() ?? '',
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      type: json['type']?.toString() ?? 'revenue',
      note: json['note']?.toString() ?? '',
      staff: json['staff']?.toString(),
      service: json['service']?.toString(),
    );
  }

  FinanceEntryEntity toEntity() {
    final entity = FinanceEntryEntity()
      ..title = title
      ..amount = amount
      ..category = category
      ..date = date
      ..type = _typeFromString(type)
      ..note = note
      ..staff = staff
      ..service = service;
    entity.id = int.tryParse(id) ?? Isar.autoIncrement;
    return entity;
  }

  EntryTypeEntity _typeFromString(String value) {
    switch (value.toLowerCase()) {
      case 'expense':
        return EntryTypeEntity.expense;
      default:
        return EntryTypeEntity.revenue;
    }
  }
}

