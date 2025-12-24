enum EmployeeStatus { active, inactive }

class EmployeeModuleKeys {
  EmployeeModuleKeys._();

  static const cashier = 'cashier';
  static const transactions = 'transactions';
  static const customers = 'customers';
  static const closing = 'closing';

  static const always = <String>[
    // Always available (not configurable in UI)
    'attendance',
    'membership',
    'sync',
  ];
}

class Employee {
  Employee({
    required this.id,
    required this.name,
    this.role = 'Staff',
    this.modules = const <String>[],
    required this.phone,
    required this.email,
    required this.joinDate,
    this.status = EmployeeStatus.active,
    this.commission,
    this.pin,
  });

  final String id;
  final String name;
  final String role;
  final List<String> modules;
  final String phone;
  final String email;
  final DateTime joinDate;
  final EmployeeStatus status;
  final double? commission;
  final String? pin;
}
