import 'package:isar_community/isar.dart';

import '../database/entities/session_entity.dart';

class SessionService {
  SessionService(this._isar);

  final Isar _isar;

  Future<SessionEntity?> load() => _isar.sessionEntitys.get(1);

  Future<int?> loadUserId() async => (await load())?.userId;

  Future<String?> loadToken() async => (await load())?.token;
  Future<String?> loadRefreshToken() async => (await load())?.refreshToken;
  Future<DateTime?> loadExpiry() async => (await load())?.expiresAt;

  Future<void> saveUserId(int? userId) async {
    await _isar.writeTxn(() async {
      await _isar.sessionEntitys.put(SessionEntity()
        ..id = 1
        ..userId = userId
        ..token = (await load())?.token
        ..refreshToken = (await load())?.refreshToken
        ..expiresAt = (await load())?.expiresAt);
    });
  }

  Future<void> saveToken({required String token, DateTime? expiresAt, int? userId}) async {
    await _isar.writeTxn(() async {
      await _isar.sessionEntitys.put(SessionEntity()
        ..id = 1
        ..token = token
        ..expiresAt = expiresAt
        ..userId = userId ?? (await load())?.userId);
    });
  }

  Future<void> saveRefreshToken({required String refreshToken}) async {
    await _isar.writeTxn(() async {
      await _isar.sessionEntitys.put(SessionEntity()
        ..id = 1
        ..refreshToken = refreshToken
        ..token = (await load())?.token
        ..expiresAt = (await load())?.expiresAt
        ..userId = (await load())?.userId);
    });
  }

  Future<void> clear() async {
    await _isar.writeTxn(() async {
      await _isar.sessionEntitys.put(SessionEntity()..id = 1);
    });
  }
}

