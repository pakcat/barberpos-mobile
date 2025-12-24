import 'package:dio/dio.dart';

import '../entities/transaction_entity.dart';

class TransactionRemoteDataSource {
  TransactionRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<TransactionEntity>> fetchAll({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final params = <String, dynamic>{};
    if (startDate != null) {
      params['startDate'] = _formatDate(startDate);
    }
    if (endDate != null) {
      params['endDate'] = _formatDate(endDate);
    }
    final res = await _dio.get<List<dynamic>>(
      '/transactions',
      queryParameters: params.isEmpty ? null : params,
    );
    final data = res.data ?? const [];
    return data.whereType<Map>().map<TransactionEntity>((raw) {
      final json = Map<String, dynamic>.from(raw);
      return TransactionEntity()
        ..id = int.tryParse(json['id']?.toString() ?? '') ?? 0
        ..code = json['code']?.toString() ?? ''
        ..date =
            DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now()
        ..time = json['time']?.toString() ?? ''
        ..amount = int.tryParse(json['amount']?.toString() ?? '') ?? 0
        ..paymentMethod = json['paymentMethod']?.toString() ?? ''
        ..status = _statusFromString(json['status']?.toString() ?? '')
        ..stylist = json['stylist']?.toString() ?? ''
        ..items = _mapItems(json['items'])
        ..customer = _mapCustomer(json['customer']);
    }).toList();
  }

  TransactionStatusEntity _statusFromString(String value) {
    return value.toLowerCase() == 'refund'
        ? TransactionStatusEntity.refund
        : TransactionStatusEntity.paid;
  }

  List<TransactionLineEntity> _mapItems(dynamic items) {
    if (items is! Iterable) return [];
    return items
        .whereType<Map>()
        .map((raw) {
          final json = Map<String, dynamic>.from(raw);
          return TransactionLineEntity()
            ..name = json['name']?.toString() ?? ''
            ..category = json['category']?.toString() ?? ''
            ..price = int.tryParse(json['price']?.toString() ?? '') ?? 0
            ..qty = int.tryParse(json['qty']?.toString() ?? '') ?? 0;
        })
        .toList();
  }

  TransactionCustomerEntity? _mapCustomer(dynamic customer) {
    if (customer is! Map) return null;
    final json = Map<String, dynamic>.from(customer);
    return TransactionCustomerEntity()
      ..name = json['name']?.toString() ?? ''
      ..phone = json['phone']?.toString() ?? ''
      ..email = json['email']?.toString() ?? ''
      ..address = json['address']?.toString() ?? ''
      ..visits = int.tryParse(json['visits']?.toString() ?? '') ?? 0
      ..lastVisit = json['lastVisit']?.toString() ?? '';
  }

  String _formatDate(DateTime date) {
    final year = date.year.toString().padLeft(4, '0');
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }
}
