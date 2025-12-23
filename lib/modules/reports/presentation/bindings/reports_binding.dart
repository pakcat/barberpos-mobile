import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/database/local_database.dart';
import '../../../../core/network/network_service.dart';
import '../../data/datasources/reports_firestore_data_source.dart';
import '../../data/datasources/finance_remote_data_source.dart';
import '../../data/repositories/reports_repository.dart';
import '../controllers/reports_controller.dart';

class ReportsBinding extends Bindings {
  @override
  void dependencies() {
    final config = Get.find<AppConfig>();
    Get.lazyPut<ReportsRepository>(
      () => ReportsRepository(
        Get.find<LocalDatabase>().isar,
        remote: config.backend == BackendMode.firebase
            ? ReportsFirestoreDataSource(FirebaseFirestore.instance)
            : null,
        restRemote: config.backend == BackendMode.rest
            ? FinanceRemoteDataSource(Get.find<NetworkService>().dio)
            : null,
      ),
    );
    Get.lazyPut<ReportsController>(() => ReportsController());
  }
}
