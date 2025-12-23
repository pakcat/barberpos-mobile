import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../core/config/app_config.dart';
import '../../data/datasources/notification_firestore_data_source.dart';
import '../controllers/notification_controller.dart';

class NotificationBinding extends Bindings {
  @override
  void dependencies() {
    final config = Get.find<AppConfig>();
    NotificationFirestoreDataSource? firebase;
    if (config.backend == BackendMode.firebase) {
      firebase = NotificationFirestoreDataSource(FirebaseFirestore.instance);
    }
    Get.lazyPut<NotificationController>(() => NotificationController(firebase: firebase, config: config));
  }
}
