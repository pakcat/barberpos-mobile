import 'package:get/get.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/network_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../domain/entities/settings_profile.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';
import '../datasources/settings_remote_data_source.dart';
import 'qris_outbox_repository.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(
    this._local, {
    SettingsRemoteDataSource? restRemote,
    AppConfig? config,
    AuthService? auth,
    QrisOutboxRepository? qrisOutbox,
  }) : _auth = auth ?? Get.find<AuthService>(),
       _qrisOutbox =
           qrisOutbox ??
           (Get.isRegistered<QrisOutboxRepository>()
               ? Get.find<QrisOutboxRepository>()
               : (throw StateError('QrisOutboxRepository not registered'))),
       _restRemote =
           restRemote ??
           ((config ?? Get.find<AppConfig>()).backend == BackendMode.rest
               ? SettingsRemoteDataSource(Get.find<NetworkService>().dio)
               : null);

  final SettingsLocalDataSource _local;
  final SettingsRemoteDataSource? _restRemote;
  final AuthService _auth;
  final QrisOutboxRepository _qrisOutbox;

  Future<String> _qrisCachePath() async {
    final dir = await getApplicationSupportDirectory();
    final folder = '${dir.path}${Platform.pathSeparator}qris_cache';
    await Directory(folder).create(recursive: true);
    return '$folder${Platform.pathSeparator}qris.jpg';
  }

  Future<Uint8List?> _loadCachedQris() async {
    try {
      final path = await _qrisCachePath();
      final f = File(path);
      if (!await f.exists()) return null;
      final bytes = await f.readAsBytes();
      return bytes.isEmpty ? null : bytes;
    } catch (_) {
      return null;
    }
  }

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

  @override
  Future<Uint8List?> loadQrisImage() async {
    final remote = _restRemote;
    if (remote == null || _auth.currentUser == null) return null;
    try {
      final bytes = await remote.loadQrisImage();
      if (bytes == null) return await _loadCachedQris();
      try {
        final path = await _qrisCachePath();
        await File(path).writeAsBytes(bytes, flush: true);
      } catch (_) {}
      return bytes;
    } catch (_) {
      return await _loadCachedQris();
    }
  }

  @override
  Future<void> saveQrisImage({
    required Uint8List bytes,
    required String filename,
    required String mimeType,
  }) async {
    final remote = _restRemote;
    if (remote == null || _auth.currentUser == null) return;
    // Always cache locally so cashier can display QRIS while offline.
    final cachePath = await _qrisCachePath();
    await File(cachePath).writeAsBytes(bytes, flush: true);

    try {
      await remote.saveQrisImage(bytes: bytes, filename: filename, mimeType: mimeType);
    } on DioException catch (e) {
      if (e.response != null) rethrow;
      await _qrisOutbox.enqueueUpload(filePath: cachePath, filename: filename, mimeType: mimeType);
      throw OfflineQueuedException('QRIS upload queued');
    }
  }

  @override
  Future<void> clearQrisImage() async {
    final remote = _restRemote;
    if (remote == null || _auth.currentUser == null) return;
    try {
      final path = await _qrisCachePath();
      try {
        final f = File(path);
        if (await f.exists()) await f.delete();
      } catch (_) {}
    } catch (_) {}

    try {
      await remote.clearQrisImage();
    } on DioException catch (e) {
      if (e.response != null) rethrow;
      await _qrisOutbox.enqueueDelete();
      throw OfflineQueuedException('QRIS delete queued');
    }
  }
}

class OfflineQueuedException implements Exception {
  OfflineQueuedException(this.message);
  final String message;
  @override
  String toString() => message;
}
