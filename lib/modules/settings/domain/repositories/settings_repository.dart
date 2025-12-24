import 'dart:typed_data';

import '../entities/settings_profile.dart';

abstract class SettingsRepository {
  Future<SettingsProfile> load();
  Future<void> save(SettingsProfile profile);
  Future<Uint8List?> loadQrisImage();
  Future<void> saveQrisImage({
    required Uint8List bytes,
    required String filename,
    required String mimeType,
  });
  Future<void> clearQrisImage();
}
