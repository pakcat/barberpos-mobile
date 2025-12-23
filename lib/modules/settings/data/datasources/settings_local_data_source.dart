import 'package:isar_community/isar.dart';

import '../../../../core/database/local_database.dart';
import '../entities/settings_entity.dart';
import '../../domain/entities/settings_profile.dart';

abstract class SettingsLocalDataSource {
  Future<SettingsProfile> load();
  Future<void> save(SettingsProfile profile);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  SettingsLocalDataSourceImpl(Future<LocalDatabase> dbReady) : _dbReady = dbReady;

  final Future<LocalDatabase> _dbReady;

  Future<Isar> get _isar async => (await _dbReady).isar;

  @override
  Future<SettingsProfile> load() async {
    final isar = await _isar;
    final stored = await isar.settingsEntitys.get(1);
    if (stored != null) return stored.toDomain();
    return SettingsProfile.defaults();
  }

  @override
  Future<void> save(SettingsProfile profile) async {
    final isar = await _isar;
    await isar.writeTxn(() async {
      await isar.settingsEntitys.put(profile.toEntity());
    });
  }
}

