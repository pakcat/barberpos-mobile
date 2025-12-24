import 'package:get/get.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/database/local_database.dart';
import '../../../../core/network/network_service.dart';
import '../../data/datasources/attendance_remote_data_source.dart';
import '../../data/repositories/attendance_repository.dart';
import '../controllers/staff_controller.dart';

class StaffBinding extends Bindings {
  @override
  void dependencies() {
    final config = Get.find<AppConfig>();
    Get.lazyPut<AttendanceRepository>(
      () => AttendanceRepository(
        Get.find<LocalDatabase>().isar,
        restRemote: config.backend == BackendMode.rest
            ? AttendanceRemoteDataSource(Get.find<NetworkService>())
            : null,
        config: config,
      ),
    );
    Get.lazyPut<StaffController>(
      () => StaffController(),
    );
  }
}
