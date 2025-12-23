import 'package:get/get.dart';

import '../../../../core/services/activity_log_service.dart';
import '../models/notification_item.dart';

class NotificationController extends GetxController {
  NotificationController({
    ActivityLogService? logs,
  }) : _logs = logs ?? Get.find<ActivityLogService>();

  final ActivityLogService _logs;

  final RxList<NotificationItem> items = <NotificationItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    items.assignAll(_logs.logs.map(_mapFromLog));
  }

  NotificationItem _mapFromLog(ActivityLog log) {
    return NotificationItem(
      title: log.title,
      message: log.message,
      actor: log.actor,
      timestamp: log.timestamp,
      type: switch (log.type) {
        ActivityLogType.error => NotificationType.error,
        ActivityLogType.warning => NotificationType.warning,
        ActivityLogType.info => NotificationType.info,
      },
    );
  }
}
