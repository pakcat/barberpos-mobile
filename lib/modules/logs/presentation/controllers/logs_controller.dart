import 'package:get/get.dart';

import '../../../../core/services/activity_log_service.dart';

class LogsController extends GetxController {
  final ActivityLogService service = Get.find<ActivityLogService>();
  final filter = 'Semua'.obs;

  List<ActivityLog> get items {
    if (filter.value == 'Semua') return service.logs;
    return service.logs.where((e) => e.type.name == filter.value.toLowerCase()).toList();
  }

  void setFilter(String value) => filter.value = value;
}
