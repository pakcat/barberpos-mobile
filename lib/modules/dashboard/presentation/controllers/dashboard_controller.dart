import 'package:get/get.dart';

import '../../../../core/network/network_service.dart';
import '../../data/datasources/dashboard_remote_data_source.dart';

class DashboardController extends GetxController {
  DashboardController({
    DashboardRemoteDataSource? remote,
    NetworkService? network,
  }) : _remote = remote ?? DashboardRemoteDataSource((network ?? Get.find<NetworkService>()).dio);

  final summary = <String, dynamic>{}.obs;
  final topServices = <Map<String, dynamic>>[].obs;
  final topStaff = <Map<String, dynamic>>[].obs;
  final salesSeries = <Map<String, dynamic>>[].obs;
  final loading = false.obs;
  final filterRange = 'Minggu ini'.obs;

  final DashboardRemoteDataSource _remote;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load({String range = 'Minggu ini'}) async {
    loading.value = true;
    try {
      final fetchedSummary = await _remote.fetchSummary();
      summary.value = fetchedSummary.toMap();

      final services = await _remote.fetchTopServices();
      topServices.assignAll(services.map((e) => e.toMap()));

      final staff = await _remote.fetchTopStaff();
      topStaff.assignAll(staff.map((e) => e.toMap()));

      final sales = await _remote.fetchSalesSeries(range: range);
      salesSeries.assignAll(sales.map((e) => e.toMap()));
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
