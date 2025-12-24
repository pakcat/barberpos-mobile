import 'package:get/get.dart';

import '../../../../core/services/activity_log_service.dart';
import '../../../transactions/data/repositories/transaction_repository.dart';
import '../../data/entities/employee_entity.dart';
import '../../data/repositories/staff_repository.dart';
import '../models/employee_model.dart';

class StaffController extends GetxController {
  StaffController({
    StaffRepository? repository,
  }) : repo = repository ?? Get.find<StaffRepository>(),
       txRepo = Get.find<TransactionRepository>(),
       logs = Get.find<ActivityLogService>();

  final StaffRepository repo;
  final TransactionRepository txRepo;
  final employees = <Employee>[].obs;
  final loading = false.obs;
  final ActivityLogService logs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    loading.value = true;
    final data = await repo.getAll();
    employees.assignAll(data.map(_map));
    loading.value = false;
  }

  Employee? getById(String id) => employees.firstWhereOrNull((e) => e.id == id);

  Future<void> upsert(Employee employee) async {
    final originalId = employee.id;
    final index = employees.indexWhere((e) => e.id == originalId);
    if (index >= 0) {
      employees[index] = employee;
    } else {
      employees.add(employee);
    }
    employees.refresh();

    final entity = _toEntity(employee);
    final saved = await repo.upsert(entity, pin: employee.pin);
    final mapped = _map(saved);

    final idx = employees.indexWhere((e) => e.id == originalId);
    if (idx != -1) {
      employees[idx] = mapped;
    } else {
      employees.removeWhere((e) => e.id == mapped.id);
      employees.add(mapped);
    }
    employees.refresh();

    logs.add(
      title: index >= 0 ? 'Ubah karyawan' : 'Tambah karyawan',
      message: employee.name.isNotEmpty
          ? '${employee.name} disimpan'
          : 'Karyawan disimpan',
      actor: 'Manager',
    );
    Get.back();
    Get.snackbar('Berhasil', 'Data karyawan disimpan');
  }

  void toggleStatus(Employee employee) {
    final newStatus = employee.status == EmployeeStatus.active
        ? EmployeeStatus.inactive
        : EmployeeStatus.active;
    upsert(
      Employee(
        id: employee.id,
        name: employee.name,
        role: employee.role,
        phone: employee.phone,
        email: employee.email,
        joinDate: employee.joinDate,
        commission: employee.commission,
        status: newStatus,
      ),
    );
    logs.add(
      title: 'Ubah status karyawan',
      message:
          '${employee.name} menjadi ${newStatus == EmployeeStatus.active ? 'Aktif' : 'Nonaktif'}',
      actor: 'Manager',
      type: ActivityLogType.warning,
    );
  }

  void resetPassword(Employee employee) {
    Get.snackbar(
      'Reset Password',
      'Password untuk ${employee.name} sudah direset',
    );
    logs.add(
      title: 'Reset password',
      message: 'Password direset untuk ${employee.name}',
      actor: 'Manager',
      type: ActivityLogType.warning,
    );
  }

  void delete(Employee employee) {
    employees.removeWhere((e) => e.id == employee.id);
    employees.refresh();
    final deleteId = int.tryParse(employee.id);
    if (deleteId == null) return;
    repo.delete(deleteId);
    Get.back();
    Get.snackbar('Berhasil', 'Karyawan dihapus');
    logs.add(
      title: 'Hapus karyawan',
      message: '${employee.name} dihapus dari sistem',
      actor: 'Manager',
      type: ActivityLogType.error,
    );
  }

  Employee _map(EmployeeEntity e) => Employee(
    id: e.id.toString(),
    name: e.name,
    role: e.role,
    modules: e.modules,
    phone: e.phone,
    email: e.email,
    joinDate: e.joinDate,
    commission: e.commission,
    status: e.active ? EmployeeStatus.active : EmployeeStatus.inactive,
  );

  EmployeeEntity _toEntity(Employee e) {
    final entity = EmployeeEntity()
      ..name = e.name
      ..role = e.role
      ..modules = e.modules.toList()
      ..phone = e.phone
      ..email = e.email
      ..joinDate = e.joinDate
      ..commission = e.commission
      ..active = e.status == EmployeeStatus.active;
    entity.id = int.tryParse(e.id) ?? 0;
    return entity;
  }

  Future<StylistStat> stylistStat(String name) async {
    final txs = (await txRepo.getAll())
        .where((t) => t.stylist.toLowerCase() == name.toLowerCase())
        .toList();
    int omzet = 0;
    int trx = txs.length;
    int itemCount = 0;
    final Map<String, int> services = {};
    for (final t in txs) {
      omzet += t.amount;
      for (final line in t.items) {
        itemCount += line.qty;
        services.update(
          line.name,
          (v) => v + line.qty,
          ifAbsent: () => line.qty,
        );
      }
    }
    return StylistStat(
      name: name,
      omzet: omzet,
      transactions: trx,
      itemsSold: itemCount,
      mostSoldService: services.entries.isEmpty
          ? ''
          : services.entries.reduce((a, b) => a.value >= b.value ? a : b).key,
    );
  }
}

class StylistStat {
  StylistStat({
    required this.name,
    required this.omzet,
    required this.transactions,
    required this.itemsSold,
    required this.mostSoldService,
  });

  final String name;
  final int omzet;
  final int transactions;
  final int itemsSold;
  final String mostSoldService;

  int get transaksi => transactions;
  int get items => itemsSold;
}
