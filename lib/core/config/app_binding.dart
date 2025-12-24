import 'package:get/get.dart';

import '../database/local_database.dart';
import '../services/activity_log_service.dart';
import '../services/sync_service.dart';
import '../services/region_service.dart';
import '../services/auth_service.dart';
import '../services/push_notification_service.dart';
import '../services/notification_service.dart';
import '../repositories/user_repository.dart';
import '../repositories/user_repository_impl.dart';
import '../../modules/management/data/repositories/management_repository.dart';
import '../../modules/management/data/datasources/management_remote_data_source.dart';
import '../../modules/product/data/repositories/product_repository.dart';
import '../../modules/product/data/datasources/product_remote_data_source.dart';
import '../../modules/staff/data/repositories/staff_repository.dart';
import '../../modules/staff/data/datasources/staff_remote_data_source.dart';
import '../../modules/staff/data/repositories/attendance_repository.dart';
import '../../modules/staff/data/datasources/attendance_remote_data_source.dart';
import '../../modules/reports/data/repositories/reports_repository.dart';
import '../../modules/reports/data/datasources/finance_remote_data_source.dart';
import '../../modules/membership/data/repositories/membership_repository.dart';
import '../../modules/membership/data/datasources/membership_remote_data_source.dart';
import '../../modules/transactions/data/repositories/transaction_repository.dart';
import '../../modules/transactions/data/datasources/transaction_remote_data_source.dart';
import '../../modules/stock/data/repositories/stock_repository.dart';
import '../../modules/stock/data/datasources/stock_remote_data_source.dart';
import '../services/session_service.dart';
import 'app_config.dart';
import '../network/network_service.dart';
import '../../modules/closing/data/repositories/closing_repository.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    // AppConfig can be overridden via Get.put before runApp or by reading dart-define.
    Get.put<AppConfig>(Get.isRegistered<AppConfig>() ? Get.find() : AppConfig.dev, permanent: true);

    final config = Get.find<AppConfig>();
    final db = Get.find<LocalDatabase>();
    final dbReady = Future<LocalDatabase>.value(db);

    Get.put<ActivityLogService>(ActivityLogService(dbReady: dbReady), permanent: true);
    Get.lazyPut<SessionService>(() => SessionService(db.isar), fenix: true);

    // Network service is registered for REST backend; safe fallback if offline/local.
    Get.lazyPut<NetworkService>(() {
      final session = Get.find<SessionService>();
      return NetworkService(config: config, session: session);
    }, fenix: true);
    Get.lazyPut<NotificationService>(() => NotificationService(), fenix: true);

    // Repositories always backed by Isar for offline; remote sync depends on backend mode.
    Get.lazyPut<RegionService>(
      () => RegionService(
        client: Get.find<NetworkService>(),
        isar: db.isar,
        config: config,
      ),
      fenix: true,
    );
    Get.lazyPut<UserRepository>(() => UserRepositoryImpl(db.isar), fenix: true);
    Get.put<ManagementRepository>(
      ManagementRepository(
        db.isar,
        remote: config.backend == BackendMode.rest
            ? ManagementRemoteDataSource(Get.find<NetworkService>().dio)
            : null,
      ),
    );
    Get.lazyPut<ProductRepository>(
      () => ProductRepository(
        db.isar,
        restRemote: config.backend == BackendMode.rest
            ? ProductRemoteDataSource(Get.find<NetworkService>().dio)
            : null,
      ),
      fenix: true,
    );
    Get.lazyPut<StaffRepository>(
      () => StaffRepository(
        db.isar,
        remote: config.backend == BackendMode.rest
            ? StaffRemoteDataSource(Get.find<NetworkService>().dio)
            : null,
      ),
      fenix: true,
    );
    Get.lazyPut<AttendanceRepository>(
      () => AttendanceRepository(
        db.isar,
        restRemote: config.backend == BackendMode.rest
            ? AttendanceRemoteDataSource(Get.find<NetworkService>())
            : null,
        config: config,
      ),
      fenix: true,
    );
    Get.lazyPut<ReportsRepository>(
      () => ReportsRepository(
        db.isar,
        restRemote: config.backend == BackendMode.rest
            ? FinanceRemoteDataSource(Get.find<NetworkService>().dio)
            : null,
      ),
      fenix: true,
    );
    Get.lazyPut<MembershipRepository>(
      () => MembershipRepository(
        db.isar,
        remote: config.backend == BackendMode.rest
            ? MembershipRemoteDataSource(Get.find<NetworkService>().dio)
            : null,
      ),
      fenix: true,
    );
    Get.put<TransactionRepository>(
      TransactionRepository(
        db.isar,
        restRemote: config.backend == BackendMode.rest
            ? TransactionRemoteDataSource(Get.find<NetworkService>().dio)
            : null,
      ),
      permanent: true,
    );
    Get.put<ClosingRepository>(ClosingRepository(db.isar), permanent: true);
    Get.lazyPut<StockRepository>(
      // Stok mengikuti data produk; tidak memakai koleksi Firestore terpisah
      () => StockRepository(
        db.isar,
        restRemote: config.backend == BackendMode.rest
            ? StockRemoteDataSource(Get.find<NetworkService>().dio)
            : null,
      ),
      fenix: true,
    );

    // AuthService available globally for splash/guards.
    Get.lazyPut<AuthService>(
      () => AuthService(
        userRepository: Get.find<UserRepository>(),
        session: Get.find<SessionService>(),
        network: Get.find<NetworkService>(),
        config: config,
      ),
      fenix: true,
    );

    // FCM token: register for rest backend (token stored via API).
    if (config.backend == BackendMode.rest) {
      Get.lazyPut<PushNotificationService>(
        () => PushNotificationService(config: config, network: Get.find<NetworkService>()),
        fenix: true,
      );
    }

    Get.put<SyncService>(SyncService(), permanent: true);
  }
}
