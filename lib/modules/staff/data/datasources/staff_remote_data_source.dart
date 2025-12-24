import 'package:dio/dio.dart';

import '../entities/employee_entity.dart';

class StaffRemoteDataSource {
  StaffRemoteDataSource(this._dio);

  final Dio _dio;

  Future<List<EmployeeEntity>> fetchAll() async {
    final res = await _dio.get<List<dynamic>>('/employees');
    final data = res.data ?? const [];
    return data.whereType<Map>().map((raw) {
      final json = Map<String, dynamic>.from(raw);
      final modulesRaw = json['modules'];
      final modules = modulesRaw is List ? modulesRaw.map((e) => e.toString()).toList() : <String>[];
      final e = EmployeeEntity()
        ..name = json['name']?.toString() ?? ''
        ..role = json['role']?.toString() ?? 'Staff'
        ..modules = modules
        ..phone = json['phone']?.toString() ?? ''
        ..email = json['email']?.toString() ?? ''
        ..commission = double.tryParse(json['commission']?.toString() ?? '') ?? 0
        ..joinDate =
            DateTime.tryParse(json['joinDate']?.toString() ?? '') ??
            DateTime.now()
        ..active = json['active'] == true;
      e.id = int.tryParse(json['id']?.toString() ?? '') ?? 0;
      return e;
    }).toList();
  }

  Future<EmployeeEntity> upsert(EmployeeEntity employee, {String? pin}) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/employees',
      data: {
        'id': _nullableId(employee.id),
        'name': employee.name,
        'role': employee.role,
        'modules': employee.modules,
        'phone': employee.phone,
        'email': employee.email,
        'joinDate': employee.joinDate.toIso8601String().split('T').first,
        'commission': employee.commission,
        'active': employee.active,
        if (pin != null && pin.isNotEmpty) 'pin': pin,
      },
    );
    final data = res.data ?? <String, dynamic>{};
    final modulesRaw = data['modules'];
    final modules = modulesRaw is List ? modulesRaw.map((e) => e.toString()).toList() : employee.modules;
    final e = EmployeeEntity()
      ..name = data['name']?.toString() ?? employee.name
      ..role = data['role']?.toString() ?? employee.role
      ..modules = modules
      ..phone = data['phone']?.toString() ?? employee.phone
      ..email = data['email']?.toString() ?? employee.email
      ..commission =
          double.tryParse(data['commission']?.toString() ?? '') ??
          employee.commission
      ..joinDate =
          DateTime.tryParse(data['joinDate']?.toString() ?? '') ??
          employee.joinDate
      ..active = data['active'] == true;
    e.id = int.tryParse(data['id']?.toString() ?? '') ?? employee.id;
    return e;
  }

  Future<void> delete(int id) => _dio.delete('/employees/$id');

  int? _nullableId(int id) => id <= 0 ? null : id;
}
