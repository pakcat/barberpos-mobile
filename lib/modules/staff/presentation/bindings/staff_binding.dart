import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/database/local_database.dart';
import '../../data/datasources/attendance_firestore_data_source.dart';
import '../../data/datasources/staff_firestore_data_source.dart';
import '../../data/repositories/attendance_repository.dart';

import '../controllers/staff_controller.dart';

class StaffBinding extends Bindings {
  @override
  void dependencies() {
    final config = Get.find<AppConfig>();
    Get.lazyPut<AttendanceRepository>(
      () => AttendanceRepository(
        Get.find<LocalDatabase>().isar,
        remote: config.backend == BackendMode.firebase
            ? AttendanceFirestoreDataSource(FirebaseFirestore.instance)
            : null,
        config: config,
      ),
    );
    Get.lazyPut<StaffController>(
      () => StaffController(
        firebase: config.backend == BackendMode.firebase
            ? StaffFirestoreDataSource(FirebaseFirestore.instance)
            : null,
        config: config,
      ),
    );
  }
}
