import 'package:get/get.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/utils/local_time.dart';
import '../../data/entities/attendance_entity.dart';
import '../../data/repositories/attendance_repository.dart';
import '../../data/repositories/staff_repository.dart';

class AttendanceSelfController extends GetxController {
  AttendanceSelfController({
    AttendanceRepository? attendanceRepository,
    AuthService? authService,
    StaffRepository? staffRepository,
  }) : _repo = attendanceRepository ?? Get.find<AttendanceRepository>(),
       _auth = authService ?? Get.find<AuthService>(),
       _staffRepo =
           staffRepository ??
           (Get.isRegistered<StaffRepository>() ? Get.find<StaffRepository>() : null);

  final AttendanceRepository _repo;
  final AuthService _auth;
  final StaffRepository? _staffRepo;

  final RxBool loading = false.obs;
  final Rxn<AttendanceEntity> today = Rxn<AttendanceEntity>();

  String get employeeName => _auth.currentUser?.name.trim() ?? '';

  @override
  void onInit() {
    super.onInit();
    refreshToday();
  }

  Future<void> refreshToday() async {
    final name = employeeName;
    loading.value = true;
    try {
      if (name.isEmpty) {
        today.value = null;
        return;
      }
      today.value = await _repo.getTodayFor(name);
    } finally {
      loading.value = false;
    }
  }

  Future<void> checkIn() async {
    final name = employeeName;
    if (name.isEmpty) {
      Get.snackbar('Absensi', 'User belum siap, coba login ulang.');
      return;
    }
    final existing = await _repo.getTodayFor(name);
    if (existing != null && existing.checkIn != null) {
      final t = asLocalTime(existing.checkIn!);
      Get.snackbar('Absensi', '$name sudah check-in pada ${_hhmm(t)}');
      today.value = existing;
      return;
    }

    final now = DateTime.now();
    final entity = AttendanceEntity()
      ..employeeId = await _resolveEmployeeId(name)
      ..employeeName = name
      ..date = DateTime(now.year, now.month, now.day)
      ..checkIn = now
      ..status = AttendanceStatus.present
      ..source = 'employee';
    final id = await _repo.upsert(entity);
    entity.id = id;
    today.value = entity;
    Get.snackbar('Absensi', 'Check-in berhasil');
  }

  Future<void> checkOut() async {
    final name = employeeName;
    if (name.isEmpty) {
      Get.snackbar('Absensi', 'User belum siap, coba login ulang.');
      return;
    }
    final existing = await _repo.getTodayFor(name);
    if (existing == null || existing.checkIn == null) {
      Get.snackbar('Absensi', 'Kamu belum check-in hari ini.');
      return;
    }
    if (existing.checkOut != null) {
      final t = asLocalTime(existing.checkOut!);
      Get.snackbar('Absensi', 'Kamu sudah check-out pada ${_hhmm(t)}');
      today.value = existing;
      return;
    }
    existing
      ..checkOut = DateTime.now()
      ..source = 'employee';
    final id = await _repo.upsert(existing);
    existing.id = id;
    today.value = existing;
    Get.snackbar('Absensi', 'Check-out berhasil');
  }

  Future<int?> _resolveEmployeeId(String name) async {
    final repo = _staffRepo;
    if (repo == null) return null;
    try {
      final items = await repo.getAll();
      final match = items.firstWhereOrNull((e) => e.name.trim() == name);
      return match?.id;
    } catch (_) {
      return null;
    }
  }

  String _hhmm(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}

class AttendanceDailyController extends GetxController {
  AttendanceDailyController({AttendanceRepository? attendanceRepository})
    : _repo = attendanceRepository ?? Get.find<AttendanceRepository>();

  final AttendanceRepository _repo;

  final RxBool loading = false.obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxList<AttendanceEntity> items = <AttendanceEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    final arg = Get.arguments;
    if (arg is DateTime) {
      selectedDate.value = arg;
    }
    refreshForSelected();
  }

  Future<void> refreshForSelected() async {
    await loadDate(selectedDate.value);
  }

  Future<void> loadDate(DateTime date) async {
    loading.value = true;
    try {
      selectedDate.value = date;
      final data = await _repo.getDaily(date);
      items.assignAll(data);
    } finally {
      loading.value = false;
    }
  }
}

