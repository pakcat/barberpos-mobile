import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:isar_community/isar.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/network_service.dart';
import '../../../../core/services/activity_log_service.dart';
import '../../../transactions/data/repositories/transaction_repository.dart';
import '../../data/datasources/staff_firestore_data_source.dart';
import '../../data/datasources/staff_remote_data_source.dart';
import '../../data/repositories/staff_repository.dart';
import '../../data/entities/employee_entity.dart';
import '../models/employee_model.dart';

class StaffController extends GetxController {
  StaffController({
    StaffRepository? repository,
    StaffFirestoreDataSource? firebase,
    StaffRemoteDataSource? restRemote,
    AppConfig? config,
    NetworkService? network,
    FirebaseFirestore? firestore,
  })  : repo = repository ?? Get.find<StaffRepository>(),
        txRepo = Get.find<TransactionRepository>(),
        logs = Get.find<ActivityLogService>(),
        _config = config ?? Get.find<AppConfig>(),
        _remote = firebase ??
            ((config ?? Get.find<AppConfig>()).backend == BackendMode.firebase
                ? StaffFirestoreDataSource(firestore ?? FirebaseFirestore.instance)
                : null),
        _rest = restRemote ??
            ((config ?? Get.find<AppConfig>()).backend == BackendMode.rest
                ? StaffRemoteDataSource((network ?? Get.find<NetworkService>()).dio)
                : null);

  final StaffRepository repo;
  final TransactionRepository txRepo;
  final employees = <Employee>[].obs;
  final loading = false.obs;
  final ActivityLogService logs;
  final AppConfig _config;
  final StaffFirestoreDataSource? _remote;
  final StaffRemoteDataSource? _rest;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  bool get _useFirebase => _config.backend == BackendMode.firebase && _remote != null;

  Future<void> _load() async {
    loading.value = true;
    if (_config.backend == BackendMode.rest && _rest != null) {
      try {
        final remote = await _rest!.fetchAll();
        await repo.replaceAll(remote);
        employees.assignAll(remote.map(_map));
        loading.value = false;
        return;
      } catch (_) {}
    }
    if (_useFirebase) {
      try {
        final remote = await _remote!.fetchAll();
        await repo.replaceAll(remote);
        employees.assignAll(remote.map(_map));
      } catch (_) {
        final data = await repo.getAll();
        employees.assignAll(data.map(_map));
      }
    } else {
      final data = await repo.getAll();
      employees.assignAll(data.map(_map));
    }
    loading.value = false;
  }

  Employee? getById(String id) => employees.firstWhereOrNull((e) => e.id == id);

  void upsert(Employee employee) {
    final index = employees.indexWhere((e) => e.id == employee.id);
    if (index >= 0) {
      employees[index] = employee;
    } else {
      employees.add(employee);
    }
    employees.refresh();
    final entity = _toEntity(employee);
    if (_config.backend == BackendMode.rest && _rest != null) {
      _rest!.upsert(entity);
    } else if (_useFirebase) {
      _remote!.upsert(entity);
    }
    repo.upsert(entity);
    logs.add(
      title: index >= 0 ? 'Ubah karyawan' : 'Tambah karyawan',
      message: '${employee.name} (${employee.role}) disimpan',
      actor: 'Manager',
    );
    Get.back();
    Get.snackbar('Berhasil', 'Data karyawan disimpan');
  }

  void toggleStatus(Employee employee) {
    final newStatus =
        employee.status == EmployeeStatus.active ? EmployeeStatus.inactive : EmployeeStatus.active;
    upsert(Employee(
      id: employee.id,
      name: employee.name,
      role: employee.role,
      phone: employee.phone,
      email: employee.email,
      joinDate: employee.joinDate,
      commission: employee.commission,
      status: newStatus,
    ));
    logs.add(
      title: 'Ubah status karyawan',
      message: '${employee.name} menjadi ${newStatus == EmployeeStatus.active ? 'Aktif' : 'Nonaktif'}',
      actor: 'Manager',
      type: ActivityLogType.warning,
    );
  }

  void resetPassword(Employee employee) {
    Get.snackbar('Reset Password', 'Password untuk ${employee.name} sudah direset');
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
    final deleteId = int.tryParse(employee.id) ?? employee.id.hashCode;
    repo.delete(deleteId);
    if (_config.backend == BackendMode.rest && _rest != null) {
      _rest!.delete(deleteId);
    } else if (_useFirebase) {
      _remote!.delete(_toEntity(employee));
    }
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
      ..phone = e.phone
      ..email = e.email
      ..joinDate = e.joinDate
      ..commission = e.commission
      ..active = e.status == EmployeeStatus.active;
    entity.id = int.tryParse(e.id) ?? Isar.autoIncrement;
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
        services.update(line.name, (v) => v + line.qty, ifAbsent: () => line.qty);
      }
    }
    final topService = services.entries.isEmpty
        ? null
        : services.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
    return StylistStat(
      omzet: omzet,
      transaksi: trx,
      items: itemCount,
      topService: topService,
    );
  }
}

class StylistStat {
  StylistStat({required this.omzet, required this.transaksi, required this.items, this.topService});
  final int omzet;
  final int transaksi;
  final int items;
  final String? topService;
}

