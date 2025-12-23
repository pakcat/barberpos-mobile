import 'package:barberpos_mobile/core/services/activity_log_service.dart';
import 'package:barberpos_mobile/core/database/local_database.dart';

class FakeActivityLogService extends ActivityLogService {
  FakeActivityLogService() : super(dbReady: Future.value(_FakeLocalDatabase()));

  @override
  Future<void> add({
    required String title,
    required String message,
    String actor = 'System',
    ActivityLogType type = ActivityLogType.info,
  }) async {
    // no-op for tests
  }
}

class _FakeLocalDatabase extends LocalDatabase {
  @override
  Future<LocalDatabase> init() async => this;
}
