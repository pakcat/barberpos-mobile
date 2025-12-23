import 'package:barberpos_mobile/core/config/app_config.dart';
import 'package:barberpos_mobile/core/network/network_service.dart';
import 'package:barberpos_mobile/core/services/session_service.dart';
import 'package:dio/dio.dart';
import 'package:barberpos_mobile/core/database/entities/session_entity.dart';

class FakeNetworkService extends NetworkService {
  FakeNetworkService()
      : super(
          config: const AppConfig(baseUrl: 'http://localhost', backend: BackendMode.rest),
          session: _FakeSession(),
        );

  @override
  Dio get dio => Dio(BaseOptions(baseUrl: 'http://localhost'));
}

class _FakeSession implements SessionService {
  @override
  Future<SessionEntity?> load() async => SessionEntity()..id = 1;

  @override
  Future<void> clear() async {}

  @override
  Future<DateTime?> loadExpiry() async => null;

  @override
  Future<String?> loadRefreshToken() async => null;

  @override
  Future<String?> loadToken() async => null;

  @override
  Future<int?> loadUserId() async => null;

  @override
  Future<void> saveRefreshToken({required String refreshToken}) async {}

  @override
  Future<void> saveToken({required String token, DateTime? expiresAt, int? userId}) async {}

  @override
  Future<void> saveUserId(int? userId) async {}
}
