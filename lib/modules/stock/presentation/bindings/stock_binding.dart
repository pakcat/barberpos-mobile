import 'package:get/get.dart';

import '../../../../core/database/local_database.dart';
import '../../data/repositories/stock_repository.dart';
import '../controllers/stock_controller.dart';

class StockBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<StockRepository>()) {
      Get.put<StockRepository>(StockRepository(Get.find<LocalDatabase>().isar), permanent: true);
    }
    Get.lazyPut<StockController>(() => StockController());
  }
}
