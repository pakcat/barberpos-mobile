import 'package:get/get.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/repositories/user_repository.dart';
import '../../../../core/services/session_service.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/network/network_service.dart';
import '../controllers/auth_controller.dart';
import '../controllers/register_controller.dart';
import '../controllers/forgot_password_controller.dart';
import '../controllers/complete_profile_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure Dio and prerequisites exist in case GlobalBindings hasn't run yet.
    if (!Get.isRegistered<AppConfig>()) {
      Get.put<AppConfig>(AppConfig.dev, permanent: true);
    }
    if (!Get.isRegistered<SessionService>()) {
      Get.put<SessionService>(SessionService(Get.find()), permanent: true);
    }
    NetworkService? network;
    if (!Get.isRegistered<NetworkService>()) {
      final config = Get.find<AppConfig>();
      final session = Get.find<SessionService>();
      network = NetworkService(config: config, session: session);
      Get.put<NetworkService>(network, permanent: true);
    } else {
      network = Get.find<NetworkService>();
    }

    Get.put<AuthService>(
      AuthService(
        userRepository: Get.find<UserRepository>(),
        logs: Get.find(),
        session: Get.find<SessionService>(),
        network: network,
        config: Get.find<AppConfig>(),
      ),
      permanent: true,
    );
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<RegisterController>(() => RegisterController());
    Get.lazyPut<ForgotPasswordController>(() => ForgotPasswordController());
    Get.lazyPut<CompleteProfileController>(() => CompleteProfileController());
  }
}
