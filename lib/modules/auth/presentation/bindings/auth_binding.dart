import 'package:get/get.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/repositories/user_repository.dart';
import '../../../../core/services/session_service.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/database/local_database.dart';
import '../../../../core/network/network_service.dart';
import '../../../../core/repositories/user_repository_impl.dart';
import '../../../../core/services/region_service.dart';
import '../controllers/auth_controller.dart';
import '../controllers/register_controller.dart';
import '../controllers/forgot_password_controller.dart';
import '../controllers/complete_profile_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // GlobalBindings normally registers these. Keep this binding robust for tests/isolated routes.
    if (!Get.isRegistered<AppConfig>()) {
      Get.put<AppConfig>(AppConfig.dev, permanent: true);
    }
    final config = Get.find<AppConfig>();

    if (!Get.isRegistered<LocalDatabase>()) {
      throw StateError('LocalDatabase is required before AuthBinding runs.');
    }
    final db = Get.find<LocalDatabase>();

    if (!Get.isRegistered<SessionService>()) {
      Get.put<SessionService>(SessionService(db.isar), permanent: true);
    }
    final session = Get.find<SessionService>();

    if (!Get.isRegistered<NetworkService>()) {
      Get.put<NetworkService>(NetworkService(config: config, session: session), permanent: true);
    }

    if (!Get.isRegistered<UserRepository>()) {
      Get.put<UserRepository>(UserRepositoryImpl(db.isar), permanent: true);
    }

    if (!Get.isRegistered<RegionService>()) {
      Get.put<RegionService>(
        RegionService(isar: db.isar, config: config, client: Get.find<NetworkService>()),
        permanent: true,
      );
    }

    if (!Get.isRegistered<AuthService>()) {
      Get.put<AuthService>(
        AuthService(
          userRepository: Get.find<UserRepository>(),
          session: session,
          network: Get.find<NetworkService>(),
          config: config,
        ),
        permanent: true,
      );
    }
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<RegisterController>(() => RegisterController());
    Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController());
    Get.lazyPut<CompleteProfileController>(() => CompleteProfileController());
  }
}
