import 'package:get/get.dart';

import '../controllers/closing_controller.dart';
import '../../data/repositories/closing_repository.dart';
import '../../../../core/database/local_database.dart';

class ClosingBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ClosingRepository>()) {
      Get.put<ClosingRepository>(ClosingRepository(Get.find<LocalDatabase>().isar), permanent: true);
    }
    Get.lazyPut<ClosingController>(() => ClosingController());
  }
}
