import 'package:isar_community/isar.dart';

import '../entities/transaction_entity.dart';

class TransactionLineDto {
  TransactionLineDto({
    required this.name,
    required this.category,
    required this.price,
    required this.qty,
  });

  final String name;
  final String category;
  final int price;
  final int qty;

  factory TransactionLineDto.fromJson(Map<String, dynamic> json) {
    return TransactionLineDto(
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      price: int.tryParse(json['price']?.toString() ?? '') ?? 0,
      qty: int.tryParse(json['qty']?.toString() ?? '') ?? 0,
    );
  }

  TransactionLineEntity toEntity() {
    return TransactionLineEntity()
      ..name = name
      ..category = category
      ..price = price
      ..qty = qty;
  }
}

class TransactionCustomerDto {
  TransactionCustomerDto({
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
    this.visits = 0,
    this.lastVisit,
  });

  final String name;
  final String phone;
  final String email;
  final String address;
  final int visits;
  final String? lastVisit;

  factory TransactionCustomerDto.fromJson(Map<String, dynamic> json) {
    return TransactionCustomerDto(
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      visits: int.tryParse(json['visits']?.toString() ?? '') ?? 0,
      lastVisit: json['lastVisit']?.toString(),
    );
  }

  TransactionCustomerEntity toEntity() {
    return TransactionCustomerEntity()
      ..name = name
      ..phone = phone
      ..email = email
      ..address = address
      ..visits = visits
      ..lastVisit = lastVisit;
  }
}

class TransactionDto {
  TransactionDto({
    required this.id,
    required this.code,
    required this.date,
    required this.time,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    required this.items,
    this.customer,
    this.stylist = '',
    this.shiftId,
    this.operatorName = '',
    this.paymentIntentId,
    this.paymentReference,
  });

  final String id;
  final String code;
  final DateTime date;
  final String time;
  final int amount;
  final String paymentMethod;
  final String status;
  final List<TransactionLineDto> items;
  final TransactionCustomerDto? customer;
  final String stylist;
  final String? shiftId;
  final String operatorName;
  final String? paymentIntentId;
  final String? paymentReference;

  factory TransactionDto.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'] as List<dynamic>? ?? <dynamic>[];
    return TransactionDto(
      id: json['id']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      time: json['time']?.toString() ?? '',
      amount: int.tryParse(json['amount']?.toString() ?? '') ?? 0,
      paymentMethod: json['paymentMethod']?.toString() ?? '',
      status: json['status']?.toString() ?? 'paid',
      items: rawItems
          .whereType<Map>()
          .map((e) => TransactionLineDto.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      customer: json['customer'] is Map<String, dynamic>
          ? TransactionCustomerDto.fromJson(json['customer'] as Map<String, dynamic>)
          : null,
      stylist: json['stylist']?.toString() ?? '',
      shiftId: json['shiftId']?.toString(),
      operatorName: json['operator']?.toString() ?? '',
      paymentIntentId: json['paymentIntentId']?.toString(),
      paymentReference: json['paymentReference']?.toString(),
    );
  }

  TransactionEntity toEntity() {
    final entity = TransactionEntity()
      ..code = code
      ..date = date
      ..time = time
      ..amount = amount
      ..paymentMethod = paymentMethod
      ..status = _statusFromString(status)
      ..items = items.map((e) => e.toEntity()).toList()
      ..customer = customer?.toEntity()
      ..stylist = stylist
      ..shiftId = shiftId
      ..operatorName = operatorName
      ..paymentIntentId = paymentIntentId
      ..paymentReference = paymentReference;
    entity.id = int.tryParse(id) ?? Isar.autoIncrement;
    return entity;
  }

  TransactionStatusEntity _statusFromString(String v) {
    switch (v.toLowerCase()) {
      case 'refund':
        return TransactionStatusEntity.refund;
      default:
        return TransactionStatusEntity.paid;
    }
  }
}

