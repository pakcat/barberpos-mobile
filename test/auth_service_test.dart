import 'package:flutter_test/flutter_test.dart';
import 'package:barberpos_mobile/core/services/auth_service.dart';

import 'fakes/fake_activity_log_service.dart';
import 'fakes/fake_session_service.dart';
import 'fakes/fake_user_repository.dart';
import 'fakes/fake_network_service.dart';
import 'stubs/stub_auth_remote.dart';

void main() {
  late FakeUserRepository userRepo;
  late FakeActivityLogService logs;
  late FakeSessionService session;
  late AuthService auth;

  setUp(() {
    userRepo = FakeUserRepository();
    logs = FakeActivityLogService();
    session = FakeSessionService();
    auth = AuthService(
      userRepository: userRepo,
      logs: logs,
      session: session,
      network: FakeNetworkService(),
      remote: StubAuthRemoteDataSource(),
    );
    auth.onInit();
  });

  test('registerWithEmail stores user and session', () async {
    final ok = await auth.registerWithEmail(
      name: 'Alice',
      email: 'alice@test.com',
      password: 'secret',
      phone: '0812',
      address: 'Street',
      region: 'Jakarta',
    );
    expect(ok, isTrue);
    expect(auth.currentUser?.email, 'alice@test.com');
    expect(await session.loadUserId(), isNotNull);
    expect(await session.loadToken(), isNotEmpty);
  });

  test('staff cannot login with Google', () async {
    await userRepo.ensureSeedUser(
      name: 'Staff',
      email: 'staff@test.com',
      password: '123',
      role: UserRole.staff,
    );
    final ok = await auth.loginWithGoogle(email: 'staff@test.com');
    expect(ok, isFalse);
    expect(auth.currentUser, isNull);
  });

  test('login fails with wrong password', () async {
    await auth.registerWithEmail(
      name: 'Bob',
      email: 'bob@test.com',
      password: 'pass',
      phone: '',
      address: '',
      region: '',
    );
    final ok = await auth.login('bob@test.com', 'wrong');
    expect(ok, isFalse);
  });

  test('login succeeds with seeded manager credentials', () async {
    final ok = await auth.login('manager@barberpos.id', 'admin123');
    expect(ok, isTrue);
    expect(auth.currentUser?.role, UserRole.manager);
    expect(await session.loadToken(), isNotEmpty);
    expect(await session.loadUserId(), isNotNull);
  });

  test('updateProfile persists changes', () async {
    await auth.registerWithEmail(
      name: 'Charlie',
      email: 'charlie@test.com',
      password: 'secret',
      phone: '',
      address: '',
      region: '',
    );

    final ok = await auth.updateProfile(
      phone: '081234',
      address: 'Jl. Sudirman',
      region: 'Jakarta',
    );

    expect(ok, isTrue);
    expect(auth.currentUser?.phone, '081234');
    expect(auth.currentUser?.address, 'Jl. Sudirman');
    expect(auth.currentUser?.region, 'Jakarta');
  });

  test('changePasswordForCurrent validates current password when required', () async {
    await auth.registerWithEmail(
      name: 'Dewi',
      email: 'dewi@test.com',
      password: 'oldpass',
      phone: '',
      address: '',
      region: '',
    );

    final fail = await auth.changePasswordForCurrent(newPassword: 'newpass', currentPassword: 'wrong');
    expect(fail, isFalse);

    final ok = await auth.changePasswordForCurrent(newPassword: 'newpass', currentPassword: 'oldpass');
    expect(ok, isTrue);
    final reLogin = await auth.login('dewi@test.com', 'newpass');
    expect(reLogin, isTrue);
  });

  test('logout clears session and current user', () async {
    await auth.registerWithEmail(
      name: 'Eva',
      email: 'eva@test.com',
      password: 'secret',
      phone: '',
      address: '',
      region: '',
    );
    await auth.logout();

    expect(auth.currentUser, isNull);
    expect(await session.loadUserId(), isNull);
    expect(await session.loadToken(), isNull);
  });
}
