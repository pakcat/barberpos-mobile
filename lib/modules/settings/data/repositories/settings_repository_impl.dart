import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/services/auth_service.dart';
import '../../domain/entities/settings_profile.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_firestore_data_source.dart';
import '../datasources/settings_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(
    this._local, {
    SettingsFirestoreDataSource? remote,
    AppConfig? config,
    AuthService? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? Get.find<AuthService>(),
        _remote = remote ??
            ((config ?? Get.find<AppConfig>()).backend == BackendMode.firebase
                ? SettingsFirestoreDataSource(firestore ?? FirebaseFirestore.instance)
                : null);

  final SettingsLocalDataSource _local;
  final SettingsFirestoreDataSource? _remote;
  final AuthService _auth;

  @override
  Future<SettingsProfile> load() async {
    final local = await _local.load();
    final remote = _remote;
    final user = _auth.currentUser;
    if (remote != null && user != null) {
      try {
        final remoteProfile = await remote.load(user.id);
        if (remoteProfile != null) {
          await _local.save(remoteProfile);
          return remoteProfile;
        }
      } catch (_) {
        // ignore remote failures
      }
    }
    return local;
  }

  @override
  Future<void> save(SettingsProfile profile) async {
    await _local.save(profile);
    final remote = _remote;
    final user = _auth.currentUser;
    if (remote != null && user != null) {
      try {
        await remote.save(user.id, profile);
      } catch (_) {
        // ignore remote failures
      }
    }
  }
}
