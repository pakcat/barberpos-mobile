import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../modules/auth/data/datasources/auth_remote_data_source.dart';
import '../../modules/auth/data/models/auth_models.dart';
import '../config/app_config.dart';
import '../database/entities/user_entity.dart';
import '../network/network_service.dart';
import '../repositories/user_repository.dart';
import 'session_service.dart';

enum UserRole { admin, manager, staff }

class AppUser {
  AppUser({
    required this.id,
    required this.name,
    required this.role,
    required this.email,
    this.phone = '',
    this.address = '',
    this.region = '',
    this.isGoogle = false,
    this.password,
  });

  final String id;
  final String name;
  final UserRole role;
  final String email;
  final String phone;
  final String address;
  final String region;
  final bool isGoogle;
  final String? password;

  AppUser copyWith({
    String? name,
    UserRole? role,
    String? email,
    String? phone,
    String? address,
    String? region,
    bool? isGoogle,
    String? password,
  }) {
    return AppUser(
      id: id,
      name: name ?? this.name,
      role: role ?? this.role,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      region: region ?? this.region,
      isGoogle: isGoogle ?? this.isGoogle,
      password: password ?? this.password,
    );
  }
}

class AuthService extends GetxService {
  AuthService({
    required UserRepository userRepository,
    required SessionService session,
    NetworkService? network,
    AuthRemoteDataSource? remote,
    AppConfig? config,
    GoogleSignIn? googleSignIn,
  }) : _userRepo = userRepository,
        _session = session,
        _remote =
            remote ??
            AuthRemoteDataSource((network ?? Get.find<NetworkService>()).dio),
        _backend =
            config?.backend ??
            (Get.isRegistered<AppConfig>()
                ? Get.find<AppConfig>().backend
                : BackendMode.local),
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  final UserRepository _userRepo;
  final SessionService _session;
  final AuthRemoteDataSource _remote;
  final BackendMode _backend;
  final GoogleSignIn _googleSignIn;
  String? _lastErrorMessage;

  final Rxn<AppUser> _currentUser = Rxn<AppUser>();
  late final Future<void> _ready;

  AppUser? get currentUser => _currentUser.value;
  bool get isLoggedIn => _currentUser.value != null;
  bool get isManager =>
      _currentUser.value?.role == UserRole.admin ||
      _currentUser.value?.role == UserRole.manager;
  bool get isStaffOnly => _currentUser.value?.role == UserRole.staff;
  String? get lastError => _lastErrorMessage;

  @override
  void onInit() {
    super.onInit();
    _ready = _init();
  }

  Future<void> _init() async {
    await _ensureSeedUser();
    await _restoreSession();
  }

  Future<void> waitUntilReady() => _ready;

  Future<void> _ensureSeedUser() async {
    await _userRepo.ensureSeedUser(
      name: 'Manager',
      email: 'manager@barberpos.id',
      password: 'admin123',
      role: UserRole.manager,
    );
  }

  Future<void> _restoreSession() async {
    final userId = await _session.loadUserId();
    if (userId == null) return;
    final user = await _userRepo.findById(userId);
    if (user != null) {
      _setUser(user);
    }
  }

  Future<bool> login(
    String username,
    String password, {
    bool staffLogin = false,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    _lastErrorMessage = null;
    final normalizedEmail = username.trim().toLowerCase();
    if (username.isEmpty || password.isEmpty) return false;
    if (staffLogin) {
      final success = await _loginStaffViaApi(
        username: normalizedEmail,
        pin: password,
      );
      return success;
    }

    if (_backend == BackendMode.rest) {
      final remoteOk = await _loginViaApi(
        username: normalizedEmail,
        password: password,
      );
      return remoteOk;
    }

    final found = await _userRepo.findByEmail(normalizedEmail);
    if (found == null) {
      _lastErrorMessage ??= 'Email atau password salah.';
      return false;
    }
    if (found.password != password) {
      _lastErrorMessage ??= 'Email atau password salah.';
      return false;
    }
    _lastErrorMessage = null;
    _setUser(found);
    await _persistSession(found.id);
    await _persistLocalTokens(userId: found.id);
    return true;
  }

  Future<bool> loginWithGoogle({
    String? idToken,
    required String email,
    String? name,
    String? phone,
    String? address,
    String? region,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    _lastErrorMessage = null;
    String? token = idToken;
    String effectiveEmail = email.trim().toLowerCase();
    String? effectiveName = name;
    if ((token == null || token.isEmpty) && _backend == BackendMode.rest) {
      try {
        final account = await _googleSignIn.signIn();
        final auth = await account?.authentication;
        token = auth?.idToken;
        if (account != null) {
          effectiveEmail = account.email;
          effectiveName = account.displayName ?? effectiveName;
        }
      } catch (_) {}
    }

    if (_backend == BackendMode.rest && token != null && token.isNotEmpty) {
      final dto = await _loginGoogleViaApi(
        idToken: token,
        email: effectiveEmail,
        name: effectiveName,
        phone: phone,
        address: address,
        region: region,
      );
      if (dto != null) {
        await _persistFromDto(dto, fallbackPassword: null);
        if (_currentUser.value?.role == UserRole.staff) {
          // Staff must use credentials created by manager, not Google.
          await logout();
          return false;
        }
        return true;
      }
    }

    if (_backend == BackendMode.rest) {
      _lastErrorMessage ??= 'Login Google gagal, coba lagi.';
      return false;
    }

    final existing = await _userRepo.findByEmail(effectiveEmail);
    if (existing != null && existing.isGoogle) {
      if (existing.role == UserRole.staff) {
        // Disallow Google login for staff accounts; they must use credentials provided by manager.
        return false;
      }
      final entity = existing
        ..phone = phone?.isNotEmpty == true ? phone! : existing.phone
        ..address = address?.isNotEmpty == true ? address! : existing.address
        ..region = region?.isNotEmpty == true ? region! : existing.region;
      await _userRepo.upsert(entity);
      _setUser(entity);
      await _persistSession(entity.id);
      await _persistLocalTokens(userId: entity.id);
      return true;
    }

    _lastErrorMessage ??= 'Login Google gagal, coba lagi.';
    return false;
  }

  Future<bool> registerWithGoogle({
    String? idToken,
    required String email,
    String? name,
    required String phone,
    required String address,
    required String region,
  }) async {
    String? token = idToken;
    String effectiveEmail = email.trim().toLowerCase();
    String? effectiveName = name;
    if ((token == null || token.isEmpty) && _backend == BackendMode.rest) {
      try {
        final account = await _googleSignIn.signIn();
        final auth = await account?.authentication;
        token = auth?.idToken;
        if (account != null) {
          effectiveEmail = account.email;
          effectiveName = account.displayName ?? effectiveName;
        }
      } catch (_) {}
    }

    if (_backend == BackendMode.rest && token != null && token.isNotEmpty) {
      final dto = await _registerGoogleViaApi(
        idToken: token,
        email: effectiveEmail,
        name: effectiveName,
        phone: phone,
        address: address,
        region: region,
      );
      if (dto != null) {
        await _persistFromDto(dto, fallbackPassword: null);
        if (_currentUser.value?.role == UserRole.staff) {
          await logout();
          return false;
        }
        return true;
      }
    }

    return false;
  }

  Future<bool> registerWithEmail({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
    required String region,
    UserRole role = UserRole.manager,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));

    if (_backend == BackendMode.rest) {
      final dto = await _registerViaApi(
        name: name,
        email: email,
        password: password,
        phone: phone,
        address: address,
        region: region,
        role: role,
      );
      if (dto != null) {
        await _persistAuthFromApi(dto, fallbackPassword: password);
        _lastErrorMessage = null;
        return true;
      }
      // When REST mode fails, do NOT fall back to local registration.
      return false;
    }

    final exists = await _userRepo.findByEmail(email);
    if (exists != null) return false;
    final entity = UserEntity()
      ..name = name
      ..role = role
      ..email = email
      ..phone = phone
      ..address = address
      ..region = region
      ..password = password;
    final savedId = await _userRepo.upsert(entity);
    entity.id = savedId;
    _setUser(entity);
    await _persistSession(entity.id);
    await _persistLocalTokens(userId: entity.id);
    await _session.saveUserId(entity.id);
    return true;
  }

  Future<bool> requestPasswordReset(String email) async {
    try {
      await _remote.requestReset(email);
    } catch (_) {
      // fallback to local notification only
      final exists = await _userRepo.findByEmail(email);
      if (exists == null) return false;
    }
    return true;
  }

  Future<bool> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      await _remote.resetPassword(token: email, password: newPassword);
    } catch (_) {
      // ignore remote failures, continue with local update
    }
    final user = await _userRepo.findByEmail(email);
    if (user == null) return false;
    user.password = newPassword;
    await _userRepo.upsert(user);
    if (_currentUser.value?.email.toLowerCase() == email.toLowerCase()) {
      _setUser(user);
    }
    return true;
  }

  Future<bool> updateProfile({
    String? name,
    String? phone,
    String? address,
    String? region,
  }) async {
    final user = _currentUser.value;
    if (user == null) return false;
    final updated = user.copyWith(
      name: name ?? user.name,
      phone: phone ?? user.phone,
      address: address ?? user.address,
      region: region ?? user.region,
    );
    final entity = _toEntity(updated);
    final savedId = await _userRepo.upsert(entity);
    entity.id = savedId;
    _setUser(entity);
    return true;
  }

  Future<bool> changePasswordForCurrent({
    required String newPassword,
    String? currentPassword,
  }) async {
    final user = _currentUser.value;
    if (user == null) return false;
    if (_backend == BackendMode.rest) {
      if (currentPassword == null || currentPassword.isEmpty) {
        _lastErrorMessage = 'Password lama wajib diisi.';
        return false;
      }
      try {
        await _remote.changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        );
        final updated = user.copyWith(password: newPassword);
        final entity = _toEntity(updated);
        await _userRepo.upsert(entity);
        _setUser(entity);
        _lastErrorMessage = null;
        return true;
      } on DioException catch (e) {
        final data = e.response?.data;
        if (data is Map && data['message'] != null) {
          _lastErrorMessage = data['message']?.toString();
        } else {
          _lastErrorMessage = 'Gagal memperbarui password.';
        }
        return false;
      } catch (_) {
        _lastErrorMessage = 'Gagal memperbarui password.';
        return false;
      }
    }
    if (user.password != null && !user.isGoogle) {
      if (currentPassword != null && currentPassword != user.password) {
        return false;
      }
    }
    return resetPassword(email: user.email, newPassword: newPassword);
  }

  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    _currentUser.value = null;
    await _session.clear();
  }

  void _setUser(UserEntity user) {
    _currentUser.value = _fromEntity(user);
  }

  Future<void> _persistSession(int? userId) => _session.saveUserId(userId);

  Future<void> _persistAuthFromApi(
    AuthResponseDto dto, {
    String? fallbackPassword,
  }) async {
    final entity = _toEntityFromDto(
      dto.user,
      fallbackPassword: fallbackPassword,
    );
    final savedId = await _userRepo.upsert(entity);
    entity.id = savedId;
    _setUser(entity);
    await _session.saveUserId(entity.id);
    final now = DateTime.now();
    final token = dto.token.isNotEmpty
        ? dto.token
        : 'local-${entity.id}-${now.millisecondsSinceEpoch}';
    final refresh = dto.refreshToken.isNotEmpty
        ? dto.refreshToken
        : 'local-refresh-${entity.id}';
    await _session.saveToken(
      token: token,
      expiresAt: dto.expiresAt ?? now.add(const Duration(hours: 12)),
      userId: entity.id,
    );
    await _session.saveRefreshToken(refreshToken: refresh);
  }

  Future<void> _persistFromDto(
    AuthResponseDto dto, {
    String? fallbackPassword,
  }) => _persistAuthFromApi(dto, fallbackPassword: fallbackPassword);

  Future<void> _persistLocalTokens({int? userId}) async {
    final now = DateTime.now();
    await _session.saveToken(
      token: 'local-$userId-${now.millisecondsSinceEpoch}',
      expiresAt: now.add(const Duration(hours: 12)),
      userId: userId,
    );
    await _session.saveRefreshToken(refreshToken: 'local-refresh-$userId');
  }

  UserEntity _toEntity(AppUser user) {
    final entity = UserEntity()
      ..name = user.name
      ..email = user.email
      ..phone = user.phone
      ..address = user.address
      ..region = user.region
      ..role = user.role
      ..isGoogle = user.isGoogle
      ..password = user.password;
    entity.id = int.tryParse(user.id) ?? entity.id;
    return entity;
  }

  AppUser _fromEntity(UserEntity e) {
    return AppUser(
      id: e.id.toString(),
      name: e.name,
      role: e.role,
      email: e.email,
      phone: e.phone,
      address: e.address,
      region: e.region,
      isGoogle: e.isGoogle,
      password: e.password,
    );
  }

  UserEntity _toEntityFromDto(UserDto dto, {String? fallbackPassword}) {
    final entity = UserEntity()
      ..name = dto.name
      ..email = dto.email
      ..phone = dto.phone
      ..address = dto.address
      ..region = dto.region
      ..role = _roleFromString(dto.role)
      ..isGoogle = dto.isGoogle
      ..password = fallbackPassword;
    entity.id = int.tryParse(dto.id) ?? entity.id;
    return entity;
  }

  UserRole _roleFromString(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'staff':
        return UserRole.staff;
      default:
        return UserRole.manager;
    }
  }

  Future<bool> _loginViaApi({
    required String username,
    required String password,
  }) async {
    try {
      final dto = await _remote.login(email: username, password: password);
      if (dto.token.isEmpty) return false;
      await _persistAuthFromApi(dto, fallbackPassword: password);
      _lastErrorMessage = null;
      return true;
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        _lastErrorMessage = data['message']?.toString();
      } else {
        _lastErrorMessage = 'Login gagal, periksa data Anda.';
      }
      return false;
    } catch (_) {
      _lastErrorMessage = 'Login gagal, periksa data Anda.';
      return false;
    }
  }

  Future<bool> _loginStaffViaApi({
    required String username,
    required String pin,
  }) async {
    if (_backend != BackendMode.rest) {
      _lastErrorMessage = 'Login karyawan hanya tersedia saat mode REST aktif.';
      return false;
    }
    try {
      final dto = await _remote.loginStaff(
        email: username.contains('@') ? username : null,
        phone: username.contains('@') ? null : username,
        pin: pin,
        name: username,
      );
      if (dto.token.isEmpty) return false;
      await _persistAuthFromApi(dto, fallbackPassword: pin);
      _lastErrorMessage = null;
      return true;
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        _lastErrorMessage = data['message']?.toString();
      } else {
        _lastErrorMessage = 'Login karyawan gagal, periksa data Anda.';
      }
      return false;
    } catch (_) {
      _lastErrorMessage = 'Login karyawan gagal, periksa data Anda.';
      return false;
    }
  }

  Future<AuthResponseDto?> _loginGoogleViaApi({
    required String idToken,
    required String email,
    String? name,
    String? phone,
    String? address,
    String? region,
  }) async {
    try {
      final dto = await _remote.loginWithGoogle(
        idToken: idToken,
        email: email,
        name: name,
        phone: phone,
        address: address,
        region: region,
      );
      if (dto.token.isEmpty) return null;
      return dto;
    } catch (_) {
      return null;
    }
  }

  Future<AuthResponseDto?> _registerGoogleViaApi({
    required String idToken,
    required String email,
    String? name,
    String? phone,
    String? address,
    String? region,
  }) async {
    try {
      final dto = await _remote.loginWithGoogle(
        idToken: idToken,
        email: email,
        name: name,
        phone: phone,
        address: address,
        region: region,
      );
      return dto.token.isEmpty ? null : dto;
    } catch (_) {
      return null;
    }
  }

  Future<AuthResponseDto?> _registerViaApi({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
    required String region,
    required UserRole role,
  }) async {
    try {
      final dto = await _remote.registerWithEmail(
        name: name,
        email: email,
        password: password,
        phone: phone,
        address: address,
        region: region,
        role: role.name,
      );
      _lastErrorMessage = null;
      return dto.token.isEmpty ? null : dto;
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        _lastErrorMessage = data['message']?.toString();
      } else {
        _lastErrorMessage = 'Registrasi gagal, periksa data Anda.';
      }
      return null;
    } catch (_) {
      _lastErrorMessage = 'Registrasi gagal, periksa data Anda.';
      return null;
    }
  }
}
