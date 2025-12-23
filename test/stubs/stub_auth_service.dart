import 'package:barberpos_mobile/core/repositories/user_repository.dart';
import 'package:barberpos_mobile/core/services/auth_service.dart';
import 'package:barberpos_mobile/core/database/entities/user_entity.dart';
import 'package:isar_community/isar.dart';
import '../fakes/fake_activity_log_service.dart';
import '../fakes/fake_network_service.dart';
import '../fakes/fake_session_service.dart';

class StubAuthService extends AuthService {
  StubAuthService()
      : _user = AppUser(
          id: '1',
          name: 'Kasir',
          role: UserRole.manager,
          email: 'kasir@test.com',
        ),
        super(
          userRepository: _DummyUserRepo(),
          logs: FakeActivityLogService(),
          session: FakeSessionService(),
          network: FakeNetworkService(),
        );

  final AppUser _user;

  @override
  AppUser? get currentUser => _user;

  @override
  bool get isLoggedIn => true;

  @override
  Future<void> logout() async {}
}

class _DummyUserRepo implements UserRepository {
  @override
  Future<void> deleteByEmail(String email) async {}

  @override
  Future<void> ensureSeedUser({required String name, required String email, required String password, UserRole role = UserRole.manager}) async {}

  @override
  Future<UserEntity?> findByEmail(String email) async => null;

  @override
  Future<UserEntity?> findById(Id id) async => null;

  @override
  Future<List<UserEntity>> getAll() async => [];

  @override
  Future<Id> upsert(UserEntity user) async => 1;
}
