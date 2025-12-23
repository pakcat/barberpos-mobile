import 'package:dio/dio.dart';

import '../entities/transaction_entity.dart';

class TransactionRemoteDataSource {
  TransactionRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<TransactionEntity>> fetchAll() async {
    final res = await _dio.get<List<dynamic>>('/transactions');
    final data = res.data ?? [];
    return data.map<TransactionEntity>((json) {
      return TransactionEntity()
        ..id = int.tryParse(json['id']?.toString() ?? '') ?? TransactionEntity().id
        ..code = json['code']?.toString() ?? ''
        ..date = DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now()
        ..time = json['time']?.toString() ?? ''
        ..amount = int.tryParse(json['amount']?.toString() ?? '') ?? 0
        ..paymentMethod = json['paymentMethod']?.toString() ?? ''
        ..status = _statusFromString(json['status']?.toString() ?? '')
        ..items = _mapItems(json['items'])
        ..customer = _mapCustomer(json['customer']);
    }).toList();
  }

  TransactionStatusEntity _statusFromString(String value) {
    return value.toLowerCase() == 'refund' ? TransactionStatusEntity.refund : TransactionStatusEntity.paid;
  }

  List<TransactionLineEntity> _mapItems(dynamic items) {
    if (items is! Iterable) return [];
    return items
        .map((raw) => TransactionLineEntity()
          ..name = raw['name']?.toString() ?? ''
          ..category = raw['category']?.toString() ?? ''
          ..price = int.tryParse(raw['price']?.toString() ?? '') ?? 0
          ..qty = int.tryParse(raw['qty']?.toString() ?? '') ?? 0)
        .toList();
  }

  TransactionCustomerEntity? _mapCustomer(dynamic customer) {
    if (customer == null) return null;
    return TransactionCustomerEntity()
      ..name = customer['name']?.toString() ?? ''
      ..phone = customer['phone']?.toString() ?? ''
      ..email = customer['email']?.toString() ?? ''
      ..address = customer['address']?.toString() ?? ''
      ..visits = int.tryParse(customer['visits']?.toString() ?? '') ?? 0
      ..lastVisit = customer['lastVisit']?.toString() ?? '';
  }
}
