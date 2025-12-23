import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/database/local_database.dart';
import '../../data/datasources/cashier_firestore_data_source.dart';
import '../../data/repositories/cashier_repository.dart';
import '../../../staff/data/datasources/attendance_firestore_data_source.dart';
import '../../../staff/data/repositories/attendance_repository.dart';
import '../../../product/data/datasources/product_firestore_data_source.dart';
import '../../../staff/data/datasources/staff_firestore_data_source.dart';
import '../../../management/data/datasources/customer_firestore_data_source.dart';
import '../../../membership/data/datasources/membership_firestore_data_source.dart';
import '../../../reports/data/datasources/reports_firestore_data_source.dart';
import '../controllers/cashier_controller.dart';

class CashierBinding extends Bindings {
  @override
  void dependencies() {
    final config = Get.find<AppConfig>();
    Get.lazyPut<CashierRepository>(() => CashierRepository(Get.find<LocalDatabase>().isar));
    Get.lazyPut<AttendanceRepository>(
      () => AttendanceRepository(
        Get.find<LocalDatabase>().isar,
        remote: config.backend == BackendMode.firebase
            ? AttendanceFirestoreDataSource(FirebaseFirestore.instance)
            : null,
        config: config,
      ),
    );
    Get.lazyPut<CashierController>(
      () => CashierController(
        firebase: config.backend == BackendMode.firebase
            ? CashierFirestoreDataSource(FirebaseFirestore.instance)
            : null,
        productFirebase: config.backend == BackendMode.firebase
            ? ProductFirestoreDataSource(FirebaseFirestore.instance)
            : null,
        staffFirebase: config.backend == BackendMode.firebase
            ? StaffFirestoreDataSource(FirebaseFirestore.instance)
            : null,
        customerFirebase: config.backend == BackendMode.firebase
            ? CustomerFirestoreDataSource(FirebaseFirestore.instance)
            : null,
        membershipFirebase: config.backend == BackendMode.firebase
            ? MembershipFirestoreDataSource(FirebaseFirestore.instance)
            : null,
        reportsFirebase: config.backend == BackendMode.firebase
            ? ReportsFirestoreDataSource(FirebaseFirestore.instance)
            : null,
        config: config,
      ),
    );
  }
}
