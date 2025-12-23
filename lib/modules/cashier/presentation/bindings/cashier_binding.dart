import 'package:get/get.dart';

import '../../../../core/database/local_database.dart';
import '../../data/repositories/cashier_repository.dart';
import '../controllers/cashier_controller.dart';

class CashierBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<CashierRepository>()) {
      Get.lazyPut<CashierRepository>(() => CashierRepository(Get.find<LocalDatabase>().isar));
    }
    Get.lazyPut<CashierController>(() => CashierController());
  }
}
