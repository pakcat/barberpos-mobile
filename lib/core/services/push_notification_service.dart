import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../config/app_config.dart';
import '../models/notification_message.dart';
import '../network/network_service.dart';
import 'notification_service.dart';

class PushNotificationService extends GetxService {
  PushNotificationService({
    FirebaseMessaging? messaging,
    AppConfig? config,
    NotificationService? notifications,
    NetworkService? network,
  })  : _messaging = messaging ?? FirebaseMessaging.instance,
        _config = config ?? Get.find<AppConfig>(),
        _notifications = notifications ?? Get.find<NotificationService>(),
        _network = network ?? (Get.isRegistered<NetworkService>() ? Get.find<NetworkService>() : null);

  final FirebaseMessaging _messaging;
  final AppConfig _config;
  final NotificationService _notifications;
  final NetworkService? _network;

  Future<void> init() async {
    if (_config.backend != BackendMode.rest) return;
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      return;
    }
    try {
      final token = await _messaging.getToken();
      if (token != null) {
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
    _notifications.add(
      title: title,
      message: body,
      type: NotificationType.info,
      syncRemote: false,
    );
  }
}
