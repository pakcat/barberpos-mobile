import 'package:get/get.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/services/activity_log_service.dart';
import '../../data/datasources/notification_firestore_data_source.dart';
import '../models/notification_item.dart';

class NotificationController extends GetxController {
  NotificationController({
    ActivityLogService? logs,
    NotificationFirestoreDataSource? firebase,
    AppConfig? config,
  })  : _logs = logs ?? Get.find<ActivityLogService>(),
        _config = config ?? Get.find<AppConfig>(),
        _firebase = firebase ??
            ((config ?? Get.find<AppConfig>()).backend == BackendMode.firebase
                ? NotificationFirestoreDataSource(FirebaseFirestore.instance)
                : null);

  final ActivityLogService _logs;
  final AppConfig _config;
  final NotificationFirestoreDataSource? _firebase;

  final RxList<NotificationItem> items = <NotificationItem>[].obs;

  bool get _useFirebase => _config.backend == BackendMode.firebase && _firebase != null;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    if (_useFirebase) {
      try {
        final remote = await _firebase!.fetchLatest();
        items.assignAll(remote);
        return;
      } catch (_) {
        // fall back to local
      }
    }
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
