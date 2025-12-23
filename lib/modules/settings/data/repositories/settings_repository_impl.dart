import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/network_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../domain/entities/settings_profile.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_firestore_data_source.dart';
import '../datasources/settings_local_data_source.dart';
import '../datasources/settings_remote_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(
    this._local, {
    SettingsFirestoreDataSource? remote,
    SettingsRemoteDataSource? restRemote,
    AppConfig? config,
    AuthService? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? Get.find<AuthService>(),
        _firebaseRemote = remote ??
            ((config ?? Get.find<AppConfig>()).backend == BackendMode.firebase
                ? SettingsFirestoreDataSource(firestore ?? FirebaseFirestore.instance)
                : null),
        _restRemote = restRemote ??
            ((config ?? Get.find<AppConfig>()).backend == BackendMode.rest
                ? SettingsRemoteDataSource(Get.find<NetworkService>().dio)
                : null);

  final SettingsLocalDataSource _local;
  final SettingsFirestoreDataSource? _firebaseRemote;
  final SettingsRemoteDataSource? _restRemote;
  final AuthService _auth;

  @override
  Future<SettingsProfile> load() async {
    final local = await _local.load();
    final user = _auth.currentUser;
    // REST takes precedence when configured
    if (_restRemote != null) {
      try {
        final remoteProfile = await _restRemote!.load();
        if (remoteProfile != null) {
          await _local.save(remoteProfile);
          return remoteProfile;
        }
      } catch (_) {}
    } else if (_firebaseRemote != null && user != null) {
      try {
        final remoteProfile = await _firebaseRemote!.load(user.id);
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
    final user = _auth.currentUser;
    if (_restRemote != null) {
      try {
        await _restRemote!.save(profile);
      } catch (_) {}
    } else if (_firebaseRemote != null && user != null) {
      try {
        await _firebaseRemote!.save(user.id, profile);
      } catch (_) {}
    }
  }
}
