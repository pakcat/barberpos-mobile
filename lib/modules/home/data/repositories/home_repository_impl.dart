import 'package:get/get.dart';

import '../../../../core/config/app_config.dart';
import '../../domain/entities/welcome_message.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_firestore_data_source.dart';
import '../datasources/home_remote_data_source.dart';

class HomeRepositoryImpl implements HomeRepository {
  HomeRepositoryImpl(
    this._remoteDataSource, {
    HomeFirestoreDataSource? firebase,
    AppConfig? config,
  })  : _firebase = firebase,
        _config = config ?? Get.find<AppConfig>();

  final HomeRemoteDataSource _remoteDataSource;
  final HomeFirestoreDataSource? _firebase;
  final AppConfig _config;

  @override
  Future<WelcomeMessage> getWelcomeMessage() async {
    final firebase = _firebase;
    if (_config.backend == BackendMode.firebase && firebase != null) {
      try {
        final welcome = await firebase.fetchWelcome();
        return welcome;
      } catch (_) {
        // fallback to remote/local
      }
    }
    return _remoteDataSource.fetchWelcomeMessage();
  }
}
