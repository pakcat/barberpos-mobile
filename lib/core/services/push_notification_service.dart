import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../config/app_config.dart';
import 'activity_log_service.dart';

class PushNotificationService extends GetxService {
  PushNotificationService({
    FirebaseMessaging? messaging,
    AppConfig? config,
    ActivityLogService? logs,
  }) : _messaging = messaging ?? FirebaseMessaging.instance,
       _config = config ?? Get.find<AppConfig>(),
       _logs = logs ?? Get.find<ActivityLogService>();

  final FirebaseMessaging _messaging;
  final AppConfig _config;
  final ActivityLogService _logs;

  Future<void> init() async {
    if (_config.backend != BackendMode.firebase) return;
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      await _logs.add(
        title: 'Notifikasi ditolak',
        message: 'Izin notifikasi tidak diberikan',
        type: ActivityLogType.warning,
      );
      return;
    }
    try {
      final token = await _messaging.getToken();
      if (token != null) {
        await _logs.add(title: 'Token FCM siap', message: token, type: ActivityLogType.info);
      }
    } catch (_) {
      // Ignore network errors during startup
    }
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final title = message.notification?.title ?? 'Notifikasi';
    final body = message.notification?.body ?? '';
    _logs.add(title: title, message: body, type: ActivityLogType.info);
  }
}
