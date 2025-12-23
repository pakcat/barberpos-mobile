import '../entities/settings_profile.dart';
import '../repositories/settings_repository.dart';

class GetSettingsUseCase {
  GetSettingsUseCase(this._repository);

  final SettingsRepository _repository;

  Future<SettingsProfile> call() => _repository.load();
}
