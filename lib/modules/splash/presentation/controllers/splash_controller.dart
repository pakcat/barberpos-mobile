import 'package:get/get.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/services/region_service.dart';
import '../../../../core/services/push_notification_service.dart';
import '../../../../routes/app_routes.dart';

class SplashController extends GetxController {
  SplashController({
    AuthService? authService,
    RegionService? regionService,
    PushNotificationService? push,
  }) : _auth = authService ?? Get.find<AuthService>(),
       _regionService = regionService ?? Get.find<RegionService>(),
       _push =
           push ??
           (Get.isRegistered<PushNotificationService>()
               ? Get.find<PushNotificationService>()
               : null);

  final AuthService _auth;
  final RegionService _regionService;
  final PushNotificationService? _push;

  final RxBool loading = true.obs;

  @override
  void onReady() {
    super.onReady();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      await _auth.waitUntilReady();
    } catch (_) {
      // Proceed even if auth ready check fails (e.g. network issue)
    }

    try {
      await _push?.init();
    } catch (_) {
      // Ignore push init errors
    }

    if (!_auth.isLoggedIn) {
      Get.offAllNamed(Routes.login);
      return;
    }

    try {
      final needsProfile = await _needsProfileCompletion();
      if (needsProfile) {
        Get.offAllNamed(Routes.completeProfile);
      } else {
        Get.offAllNamed(Routes.home);
      }
    } catch (_) {
      // If profile check fails, default to home (offline mode likely)
      Get.offAllNamed(Routes.home);
    }
  }

  Future<bool> _needsProfileCompletion() async {
    final user = _auth.currentUser;
    if (user == null) return false;
    if (user.phone.trim().isNotEmpty &&
        user.address.trim().isNotEmpty &&
        user.region.trim().isNotEmpty) {
      return false;
    }
    if (_regionService.regions.isEmpty) {
      await _regionService.load();
    }
    return true;
  }
}
