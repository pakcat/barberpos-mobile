import 'package:barberpos_mobile/core/services/session_service.dart';
import 'package:barberpos_mobile/core/database/entities/session_entity.dart';

class FakeSessionService implements SessionService {
  int? _userId;
  String? _token;
  String? _refresh;
  DateTime? _exp;

  @override
  Future<SessionEntity?> load() async => SessionEntity()..id = 1;

  @override
  Future<void> clear({bool purgeLocalData = true}) async {
    _userId = null;
    _token = null;
    _refresh = null;
    _exp = null;
  }

  @override
  Future<DateTime?> loadExpiry() async => _exp;

  @override
  Future<String?> loadRefreshToken() async => _refresh;

  @override
  Future<String?> loadToken() async => _token;

  @override
  Future<int?> loadUserId() async => _userId;

  @override
  Future<void> saveRefreshToken({required String refreshToken}) async {
    _refresh = refreshToken;
  }

  @override
  Future<void> saveToken({
    required String token,
    DateTime? expiresAt,
    int? userId,
  }) async {
    _token = token;
    _exp = expiresAt;
    _userId = userId ?? _userId;
  }

  @override
  Future<void> saveUserId(int? userId) async {
    _userId = userId;
  }
}
