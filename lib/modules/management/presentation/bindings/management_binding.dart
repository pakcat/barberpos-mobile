import 'package:get/get.dart';

import '../../../../core/database/local_database.dart';
import '../../../../core/network/network_service.dart';
import '../../../../core/config/app_config.dart';
import '../../data/datasources/management_remote_data_source.dart';
import '../../data/repositories/management_repository.dart';
import '../controllers/management_controller.dart';

class ManagementBinding extends Bindings {
  @override
  void dependencies() {
    final config = Get.find<AppConfig>();
    Get.lazyPut<ManagementRepository>(
      () => ManagementRepository(
        Get.find<LocalDatabase>().isar,
        remote: config.backend == BackendMode.rest
            ? ManagementRemoteDataSource(Get.find<NetworkService>().dio)
            : null,
      ),
    );
    Get.lazyPut<ManagementController>(() => ManagementController());
  }
}
