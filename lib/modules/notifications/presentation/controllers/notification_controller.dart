import 'package:get/get.dart';

import '../../../../core/models/notification_message.dart';
import '../../../../core/services/notification_service.dart';

class NotificationController extends GetxController {
  NotificationController({NotificationService? notifications})
    : _notifications = notifications ?? Get.find<NotificationService>();

  final NotificationService _notifications;

  @override
  void onInit() {
    super.onInit();
    _notifications.refresh();
  }

  RxList<NotificationMessage> get items => _notifications.notifications;
}
