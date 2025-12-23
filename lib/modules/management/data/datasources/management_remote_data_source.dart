import 'package:dio/dio.dart';

import '../entities/category_entity.dart';
import '../entities/customer_entity.dart';

class ManagementRemoteDataSource {
  ManagementRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<CategoryEntity>> fetchCategories() async {
    final res = await _dio.get<List<dynamic>>('/categories');
    final data = res.data ?? const [];
    return data.map((raw) {
      final e = CategoryEntity()..name = raw['name']?.toString() ?? '';
      e.id = _toId(raw['id']);
      return e;
    }).toList();
  }

  Future<List<CustomerEntity>> fetchCustomers() async {
    final res = await _dio.get<List<dynamic>>('/customers');
    final data = res.data ?? const [];
    return data.map((raw) {
      final e = CustomerEntity()
        ..name = raw['name']?.toString() ?? ''
        ..phone = raw['phone']?.toString() ?? ''
        ..email = raw['email']?.toString() ?? ''
        ..address = raw['address']?.toString() ?? '';
      e.id = _toId(raw['id']);
      return e;
    }).toList();
  }

  Future<CategoryEntity> upsertCategory(CategoryEntity category) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/categories',
      data: {'id': _nullableId(category.id), 'name': category.name},
    );
    final data = res.data ?? <String, dynamic>{};
    final e = CategoryEntity()..name = data['name']?.toString() ?? category.name;
    e.id = _toId(data['id']);
    return e;
  }

  Future<void> deleteCategory(int id) => _dio.delete('/categories/$id');

  Future<CustomerEntity> upsertCustomer(CustomerEntity customer) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/customers',
      data: {
        'id': _nullableId(customer.id),
        'name': customer.name,
        'phone': customer.phone,
        'email': customer.email,
        'address': customer.address,
      },
    );
    final data = res.data ?? <String, dynamic>{};
    final e = CustomerEntity()
      ..name = data['name']?.toString() ?? customer.name
      ..phone = data['phone']?.toString() ?? customer.phone
      ..email = data['email']?.toString() ?? customer.email
      ..address = data['address']?.toString() ?? customer.address;
    e.id = _toId(data['id']);
    return e;
  }

  Future<void> deleteCustomer(int id) => _dio.delete('/customers/$id');

  int _toId(dynamic value) => int.tryParse(value?.toString() ?? '') ?? 0;
  int? _nullableId(int id) => id <= 0 ? null : id;
}
