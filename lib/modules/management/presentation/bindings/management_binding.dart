import 'package:get/get.dart';

import '../../../../core/database/local_database.dart';
import '../../data/repositories/management_repository.dart';
import '../controllers/management_controller.dart';

class ManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManagementRepository>(
      () => ManagementRepository(Get.find<LocalDatabase>().isar),
    );
    Get.lazyPut<ManagementController>(() => ManagementController());
  }
}
