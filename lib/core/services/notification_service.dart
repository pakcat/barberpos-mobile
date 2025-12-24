import 'package:get/get.dart';

import '../config/app_config.dart';
import '../models/notification_message.dart';
import '../network/network_service.dart';

class NotificationService extends GetxService {
  NotificationService({
    AppConfig? config,
    NetworkService? network,
  })  : _config = config ?? Get.find<AppConfig>(),
        _network = network ?? (Get.isRegistered<NetworkService>() ? Get.find<NetworkService>() : null);

  final AppConfig _config;
  final NetworkService? _network;

  final RxList<NotificationMessage> notifications = <NotificationMessage>[].obs;

  bool get _useRest => _config.backend == BackendMode.rest && _network != null;

  Future<void> refresh() async {
    if (!_useRest) return;
    try {
      final res = await _network!.dio.get<List<dynamic>>('/notifications');
      final data = res.data ?? const [];
      final items = data.map(_fromJson).toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
      notifications.assignAll(items);
    } catch (_) {}
  }

  Future<void> add({
    required String title,
    required String message,
    NotificationType type = NotificationType.info,
  }) async {
    final item = NotificationMessage(title: title, message: message, type: type);
    notifications.insert(0, item);
    if (!_useRest) return;
    try {
      final res = await _network!.dio.post<Map<String, dynamic>>(
        '/notifications',
        data: {
          'title': title,
          'message': message,
          'type': type.name,
          'timestamp': item.timestamp.toIso8601String(),
        },
      );
      final saved = _fromJson(res.data ?? {});
      final index = notifications.indexWhere(
        (n) => n.timestamp == item.timestamp && n.title == item.title && n.message == item.message,
      );
      if (index != -1) {
        notifications[index] = saved;
      }
    } catch (_) {}
  }

  NotificationMessage _fromJson(dynamic raw) {
    if (raw is! Map) {
      return NotificationMessage(title: 'Notifikasi', message: '');
    }
    final title = raw['title']?.toString() ?? 'Notifikasi';
    final message = raw['message']?.toString() ?? '';
    final type = _typeFromString(raw['type']?.toString() ?? '');
    final timestamp = DateTime.tryParse(raw['timestamp']?.toString() ?? '');
    final id = int.tryParse(raw['id']?.toString() ?? '');
    return NotificationMessage(
      id: id,
      title: title,
      message: message,
      type: type,
      timestamp: timestamp ?? DateTime.now(),
    );
  }

  NotificationType _typeFromString(String value) {
    switch (value.toLowerCase()) {
      case 'warning':
        return NotificationType.warning;
      case 'error':
        return NotificationType.error;
      default:
        return NotificationType.info;
    }
  }
}
