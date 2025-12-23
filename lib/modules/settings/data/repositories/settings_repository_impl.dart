import 'package:get/get.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/network_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../domain/entities/settings_profile.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';
import '../datasources/settings_remote_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(
    this._local, {
    SettingsRemoteDataSource? restRemote,
    AppConfig? config,
    AuthService? auth,
  })  : _auth = auth ?? Get.find<AuthService>(),
        _restRemote = restRemote ??
            ((config ?? Get.find<AppConfig>()).backend == BackendMode.rest
                ? SettingsRemoteDataSource(Get.find<NetworkService>().dio)
                : null);

  final SettingsLocalDataSource _local;
  final SettingsRemoteDataSource? _restRemote;
  final AuthService _auth;

  @override
  Future<SettingsProfile> load() async {
    final local = await _local.load();
    final remote = _restRemote;
    if (remote != null) {
      try {
        final remoteProfile = await remote.load();
        if (remoteProfile != null) {
          await _local.save(remoteProfile);
          return remoteProfile;
        }
      } catch (_) {}
    }
    return local;
  }

  @override
  Future<void> save(SettingsProfile profile) async {
    await _local.save(profile);
    final remote = _restRemote;
    if (remote != null && _auth.currentUser != null) {
      try {
        await remote.save(profile);
      } catch (_) {}
    }
  }
}
