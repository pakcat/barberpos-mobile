import 'package:get/get.dart';

import '../../../../core/database/local_database.dart';
import '../../../../core/config/app_config.dart';
import '../../data/datasources/settings_local_data_source.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/usecases/get_settings.dart';
import '../../domain/usecases/save_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../controllers/settings_controller.dart';
import '../../../../core/services/session_service.dart';
import '../../../../core/network/network_service.dart';
import '../../data/datasources/settings_firestore_data_source.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/services/auth_service.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    final Future<LocalDatabase> dbReady = Get.isRegistered<LocalDatabase>()
        ? Future.value(Get.find<LocalDatabase>())
        : Get.putAsync<LocalDatabase>(() => LocalDatabase().init(), permanent: true);

    // Ensure base config and network client exist for any remote calls triggered from settings flows.
    if (!Get.isRegistered<AppConfig>()) {
      Get.put<AppConfig>(AppConfig.dev, permanent: true);
    }
    final sessionReady = Get.putAsync<SessionService>(() async {
      final db = await dbReady;
      return Get.isRegistered<SessionService>() ? Get.find<SessionService>() : SessionService(db.isar);
    }, permanent: true);
    Get.putAsync<NetworkService>(() async {
      final config = Get.find<AppConfig>();
      final session = await sessionReady;
      return Get.isRegistered<NetworkService>()
          ? Get.find<NetworkService>()
          : NetworkService(config: config, session: session);
    }, permanent: true);

    Get.lazyPut<SettingsLocalDataSource>(
      () => SettingsLocalDataSourceImpl(dbReady),
    );
    SettingsFirestoreDataSource? remote;
    final config = Get.find<AppConfig>();
    if (config.backend == BackendMode.firebase) {
      remote = SettingsFirestoreDataSource(FirebaseFirestore.instance);
    }
    Get.lazyPut<SettingsRepository>(
      () => SettingsRepositoryImpl(
        Get.find<SettingsLocalDataSource>(),
        remote: remote,
        config: config,
        auth: Get.find<AuthService>(),
        firestore: remote == null ? null : FirebaseFirestore.instance,
      ),
    );
    Get.lazyPut<GetSettingsUseCase>(
      () => GetSettingsUseCase(Get.find<SettingsRepository>()),
    );
    Get.lazyPut<SaveSettingsUseCase>(
      () => SaveSettingsUseCase(Get.find<SettingsRepository>()),
    );
    Get.lazyPut<SettingsController>(
      () => SettingsController(
        getSettings: Get.find<GetSettingsUseCase>(),
        saveSettings: Get.find<SaveSettingsUseCase>(),
      ),
    );
  }
}
