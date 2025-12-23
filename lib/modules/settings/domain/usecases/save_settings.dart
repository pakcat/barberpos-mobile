import '../entities/settings_profile.dart';
import '../repositories/settings_repository.dart';

class SaveSettingsUseCase {
  SaveSettingsUseCase(this._repository);

  final SettingsRepository _repository;

  Future<void> call(SettingsProfile profile) => _repository.save(profile);
}
