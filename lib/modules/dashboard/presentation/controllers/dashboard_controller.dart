import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/network_service.dart';
import '../../data/datasources/dashboard_firestore_data_source.dart';
import '../../data/datasources/dashboard_remote_data_source.dart';

class DashboardController extends GetxController {
  DashboardController({
    DashboardRemoteDataSource? remote,
    DashboardFirestoreDataSource? firebase,
    AppConfig? config,
    NetworkService? network,
    FirebaseFirestore? firestore,
  })  : _config = config ?? Get.find<AppConfig>(),
        _remote = remote ?? DashboardRemoteDataSource((network ?? Get.find<NetworkService>()).dio),
        _firebase = firebase ??
            ((config ?? Get.find<AppConfig>()).backend == BackendMode.firebase
                ? DashboardFirestoreDataSource(firestore ?? FirebaseFirestore.instance)
                : null);

  final AppConfig _config;
  final summary = <String, dynamic>{}.obs;
  final topServices = <Map<String, dynamic>>[].obs;
  final topStaff = <Map<String, dynamic>>[].obs;
  final salesSeries = <Map<String, dynamic>>[].obs;
  final loading = false.obs;
  final filterRange = 'Minggu ini'.obs;

  final DashboardRemoteDataSource _remote;
  final DashboardFirestoreDataSource? _firebase;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load({String range = 'Minggu ini'}) async {
    loading.value = true;
    try {
      final firebase = _firebase;
      if (_config.backend == BackendMode.firebase && firebase != null) {
        final fetchedSummary = await firebase.fetchSummary();
        summary.value = fetchedSummary.toMap();

        final services = await firebase.fetchTopServices();
        topServices.assignAll(services.map((e) => e.toMap()));

        final staff = await firebase.fetchTopStaff();
        topStaff.assignAll(staff.map((e) => e.toMap()));

        final sales = await firebase.fetchSalesSeries(range: range);
        salesSeries.assignAll(sales.map((e) => e.toMap()));
      } else {
        final fetchedSummary = await _remote.fetchSummary();
        summary.value = fetchedSummary.toMap();

        final services = await _remote.fetchTopServices();
        topServices.assignAll(services.map((e) => e.toMap()));

        final staff = await _remote.fetchTopStaff();
        topStaff.assignAll(staff.map((e) => e.toMap()));

        final sales = await _remote.fetchSalesSeries(range: range);
        salesSeries.assignAll(sales.map((e) => e.toMap()));
      }
    } catch (_) {
      summary.clear();
      topServices.clear();
      topStaff.clear();
      salesSeries.clear();
    } finally {
      filterRange.value = range;
      loading.value = false;
    }
  }
}
