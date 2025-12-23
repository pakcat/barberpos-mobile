import '../entities/settings_profile.dart';

abstract class SettingsRepository {
  Future<SettingsProfile> load();
  Future<void> save(SettingsProfile profile);
}
