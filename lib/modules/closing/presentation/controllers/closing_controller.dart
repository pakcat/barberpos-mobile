import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/network_service.dart';
import '../../../../core/services/activity_log_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../data/datasources/closing_firestore_data_source.dart';
import '../../data/datasources/closing_remote_data_source.dart';
import '../../data/entities/closing_history_entity.dart';
import '../../data/repositories/closing_repository.dart';

class ClosingController extends GetxController {
  ClosingController({
    ClosingRepository? repository,
    ClosingRemoteDataSource? remote,
    ClosingFirestoreDataSource? firebaseRemote,
    AppConfig? config,
    FirebaseFirestore? firestore,
  })  : auth = Get.find<AuthService>(),
        logs = Get.find<ActivityLogService>(),
        repo = repository ?? Get.find<ClosingRepository>(),
        _config = config ?? Get.find<AppConfig>(),
        _remote = remote ??
            (Get.isRegistered<NetworkService>()
                ? ClosingRemoteDataSource(Get.find<NetworkService>().dio)
                : null),
        _firebaseRemote = firebaseRemote ??
            ((config ?? Get.find<AppConfig>()).backend == BackendMode.firebase
                ? ClosingFirestoreDataSource(firestore ?? FirebaseFirestore.instance)
                : null);

  final AuthService auth;
  final ActivityLogService logs;
  final ClosingRepository repo;
  final AppConfig _config;
  final ClosingRemoteDataSource? _remote;
  final ClosingFirestoreDataSource? _firebaseRemote;

  final totalCash = 520000.obs;
  final totalNonCash = 310000.obs;
  final totalCard = 180000.obs;
  final note = ''.obs;
  final physicalCash = ''.obs;
  final loading = false.obs;
  final history = <ClosingHistoryEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  bool get _useFirebase => _config.backend == BackendMode.firebase && _firebaseRemote != null;

  Future<void> _load() async {
    if (_useFirebase) {
      await _loadFromFirebase();
    } else {
      await _loadSummaryFromApi();
      final data = await repo.getAll();
      history.assignAll(data);
    }
  }

Future<void> _loadSummaryFromApi() async {
    final remote = _remote;
    if (remote == null) return;
    try {
      final summary = await remote.fetchSummary();
      totalCash.value = summary.totalCash;
      totalNonCash.value = summary.totalNonCash;
      totalCard.value = summary.totalCard;
    } catch (_) {
      // keep defaults for offline mode
    }
  }

  Future<void> _loadFromFirebase() async {
    final firebaseRemote = _firebaseRemote;
    if (firebaseRemote == null) return;
    try {
      final summary = await firebaseRemote.fetchSummary();
      totalCash.value = summary.totalCash;
      totalNonCash.value = summary.totalNonCash;
      totalCard.value = summary.totalCard;
    } catch (_) {
      // ignore and keep defaults
    }
    try {
      final remoteHistory = await firebaseRemote.fetchHistory();
      await repo.replaceAll(remoteHistory);
      history.assignAll(remoteHistory);
    } catch (_) {
      final data = await repo.getAll();
      history.assignAll(data);
    }
  }

  void setNote(String v) => note.value = v;
  void setPhysicalCash(String v) => physicalCash.value = v;

  Future<void> submitClosing() async {
    loading.value = true;
    await Future<void>.delayed(const Duration(milliseconds: 350));
    loading.value = false;
    final now = DateTime.now();
    final shiftId = _generateShiftId(now);
    final entry = ClosingHistoryEntity()
      ..tanggal = now
      ..shift = 'Shift Sore'
      ..karyawan = auth.currentUser?.name ?? 'Karyawan'
      ..operatorName = auth.currentUser?.name ?? 'Karyawan'
      ..shiftId = shiftId
      ..total = totalCash.value + totalNonCash.value + totalCard.value
      ..status = 'Selesai'
      ..catatan = note.value
      ..fisik = physicalCash.value;
    final id = await repo.add(entry);
    history.insert(0, entry..id = id);
    if (_useFirebase) {
      try {
        final firebaseRemote = _firebaseRemote;
        if (firebaseRemote == null) return;
        await firebaseRemote.submitClosing({
          'tanggal': entry.tanggal.toIso8601String(),
          'shift': entry.shift,
          'karyawan': entry.karyawan,
          'operator': entry.operatorName,
          'shiftId': entry.shiftId,
          'totalCash': totalCash.value,
          'totalNonCash': totalNonCash.value,
          'totalCard': totalCard.value,
          'catatan': note.value,
          'fisik': physicalCash.value,
          'status': entry.status,
        });
      } catch (_) {
        // keep local-only if offline
      }
    } else if (_remote != null) {
      try {
        final remote = _remote;
        await remote.submitClosing({
          'tanggal': entry.tanggal.toIso8601String(),
          'shift': entry.shift,
          'karyawan': entry.karyawan,
          'operator': entry.operatorName,
          'shiftId': entry.shiftId,
          'totalCash': totalCash.value,
          'totalNonCash': totalNonCash.value,
          'totalCard': totalCard.value,
          'catatan': note.value,
          'fisik': physicalCash.value,
          'status': entry.status,
        });
      } catch (_) {
        // keep local-only if API unavailable
      }
    }
    logs.add(
      title: 'Tutup buku',
      message:
          'Shift ditutup oleh ${auth.currentUser?.name ?? 'Karyawan'} dengan total Rp${totalCash.value + totalNonCash.value + totalCard.value}',
      actor: auth.currentUser?.name ?? 'Karyawan',
    );
    Get.snackbar('Tutup buku', 'Shift berhasil ditutup');
    Get.back();
  }

  String _generateShiftId(DateTime now) {
    final name = auth.currentUser?.name ?? 'operator';
    return 'SHIFT-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-'
        '${name.replaceAll(' ', '').toLowerCase()}';
  }
}
