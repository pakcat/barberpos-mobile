import 'package:get/get.dart';

import '../../../../core/database/local_database.dart';
import '../../data/repositories/membership_repository.dart';
import '../controllers/membership_controller.dart';

class MembershipBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MembershipRepository>(
      () => MembershipRepository(Get.find<LocalDatabase>().isar),
    );
    Get.lazyPut<MembershipController>(() => MembershipController());
  }
}
