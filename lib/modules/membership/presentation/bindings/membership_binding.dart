import 'package:get/get.dart';

import '../../../../core/database/local_database.dart';
import '../../../../core/network/network_service.dart';
import '../../../../core/config/app_config.dart';
import '../../data/datasources/membership_remote_data_source.dart';
import '../../data/repositories/membership_repository.dart';
import '../controllers/membership_controller.dart';

class MembershipBinding extends Bindings {
  @override
  void dependencies() {
    final config = Get.find<AppConfig>();
    Get.lazyPut<MembershipRepository>(
      () => MembershipRepository(
        Get.find<LocalDatabase>().isar,
        remote: config.backend == BackendMode.rest
            ? MembershipRemoteDataSource(Get.find<NetworkService>().dio)
            : null,
      ),
    );
    Get.lazyPut<MembershipController>(() => MembershipController());
  }
}
