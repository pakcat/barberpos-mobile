import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../config/app_config.dart';
import '../network/network_service.dart';
import 'activity_log_service.dart';

class PushNotificationService extends GetxService {
  PushNotificationService({
    FirebaseMessaging? messaging,
    AppConfig? config,
    ActivityLogService? logs,
    NetworkService? network,
  })  : _messaging = messaging ?? FirebaseMessaging.instance,
        _config = config ?? Get.find<AppConfig>(),
        _logs = logs ?? Get.find<ActivityLogService>(),
        _network = network ?? (Get.isRegistered<NetworkService>() ? Get.find<NetworkService>() : null);

  final FirebaseMessaging _messaging;
  final AppConfig _config;
  final ActivityLogService _logs;
  final NetworkService? _network;

  Future<void> init() async {
    if (_config.backend != BackendMode.firebase && _config.backend != BackendMode.rest) return;
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
        final network = _network;
        if (_config.backend == BackendMode.rest && network != null) {
          try {
            await network.dio.post(
              '/notifications/token',
              data: {
                'token': token,
                'platform': GetPlatform.isAndroid
                    ? 'android'
                    : GetPlatform.isIOS
                        ? 'ios'
                        : 'unknown',
              },
              );
          } catch (_) {
            // ignore failure to register token, will retry on next app start
          }
        }
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
