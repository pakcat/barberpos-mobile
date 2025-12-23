import 'dart:math';

import '../services/auth_service.dart';
import '../../modules/staff/presentation/models/employee_model.dart';

class DataRepository {
  final _rng = Random();

  // Employees
  final employees = <Employee>[
    Employee(
      id: 'emp-1',
      name: 'Budi Gunawan',
      role: 'Barber',
      phone: '0812-3456-7890',
      email: 'budi@barberpos.id',
      joinDate: DateTime(2023, 5, 10),
      commission: 10,
    ),
    Employee(
      id: 'emp-2',
      name: 'Siti Aminah',
      role: 'Kasir',
      phone: '0813-2222-3333',
      email: 'siti@barberpos.id',
      joinDate: DateTime(2024, 1, 12),
    ),
  ];

  // Closing history
  final closingHistory = <Map<String, dynamic>>[];

  // Dashboard metrics (mock)
  Map<String, dynamic> dashboardSummary() {
    return {
      'transaksiHariIni': 24 + _rng.nextInt(10),
      'omzetHariIni': 3500000 + _rng.nextInt(800000),
      'customerHariIni': 18 + _rng.nextInt(6),
      'layananTerjual': 42 + _rng.nextInt(15),
    };
  }

  List<Map<String, dynamic>> dashboardTopServices() {
    return [
      {'name': 'Haircut', 'qty': 25, 'amount': 1250000},
      {'name': 'Shave', 'qty': 14, 'amount': 420000},
      {'name': 'Coloring', 'qty': 6, 'amount': 1800000},
      {'name': 'Treatment', 'qty': 8, 'amount': 640000},
      {'name': 'Styling', 'qty': 10, 'amount': 500000},
    ];
  }

  List<Map<String, dynamic>> dashboardTopStaff() {
    return [
      {'name': 'Budi', 'role': 'Barber', 'transaksi': 15, 'omzet': 1850000},
      {'name': 'Siti', 'role': 'Kasir', 'transaksi': 12, 'omzet': 1420000},
      {'name': 'Andi', 'role': 'Barber', 'transaksi': 10, 'omzet': 980000},
    ];
  }

  // Reports mock
  List<Map<String, dynamic>> reportEntries({int count = 12}) {
    return List.generate(count, (i) {
      final amount = 150000 + _rng.nextInt(600000);
      final date = DateTime.now().subtract(Duration(days: i));
      return {
        'id': 'REP-$i',
        'date': date,
        'amount': amount,
        'method': i.isEven ? 'Cash' : 'E-Wallet',
        'staff': i.isEven ? 'Budi' : 'Siti',
        'service': i.isEven ? 'Haircut' : 'Shave',
      };
    });
  }

  void addClosing({
    required int totalCash,
    required int totalNonCash,
    required int totalCard,
    required String note,
    required String physicalCash,
    required AppUser user,
  }) {
    closingHistory.insert(0, {
      'tanggal': DateTime.now(),
      'shift': 'Shift Sore',
      'karyawan': user.name,
      'total': totalCash + totalNonCash + totalCard,
      'status': 'Selesai',
      'catatan': note,
      'fisik': physicalCash,
    });
  }
}
