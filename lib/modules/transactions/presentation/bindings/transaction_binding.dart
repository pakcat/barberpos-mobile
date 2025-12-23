import 'package:get/get.dart';

import '../../../../core/database/local_database.dart';
import '../../data/repositories/transaction_repository.dart';
import '../controllers/transaction_controller.dart';

class TransactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransactionRepository>(
      () => TransactionRepository(Get.find<LocalDatabase>().isar),
    );
    Get.lazyPut<TransactionController>(() => TransactionController());
  }
}
