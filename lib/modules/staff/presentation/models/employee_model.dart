enum EmployeeStatus { active, inactive }

class Employee {
  Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.phone,
    required this.email,
    required this.joinDate,
    this.status = EmployeeStatus.active,
    this.commission,
    this.password,
  });

  final String id;
  final String name;
  final String role;
  final String phone;
  final String email;
  final DateTime joinDate;
  final EmployeeStatus status;
  final double? commission;
  final String? password;
}
