import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../modules/auth/data/datasources/auth_remote_data_source.dart';
import '../../modules/auth/data/models/auth_models.dart';
import '../config/app_config.dart';
import '../database/entities/user_entity.dart';
import '../network/network_service.dart';
import '../repositories/user_repository.dart';
import 'activity_log_service.dart';
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
    required ActivityLogService logs,
    required SessionService session,
    NetworkService? network,
    AuthRemoteDataSource? remote,
    AppConfig? config,
    fb_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
    FirebaseFirestore? firestore,
  })  : _userRepo = userRepository,
        _logs = logs,
        _session = session,
        _remote = remote ?? AuthRemoteDataSource((network ?? Get.find<NetworkService>()).dio),
        _backend = config?.backend ?? BackendMode.rest,
        _firebaseAuth =
            firebaseAuth ?? (config?.backend == BackendMode.firebase ? fb_auth.FirebaseAuth.instance : null),
        _googleSignIn = googleSignIn ?? (config?.backend == BackendMode.firebase ? GoogleSignIn() : null),
        _firestore =
            firestore ?? (config?.backend == BackendMode.firebase ? FirebaseFirestore.instance : null);

  final UserRepository _userRepo;
  final ActivityLogService _logs;
  final SessionService _session;
  final AuthRemoteDataSource _remote;
  final BackendMode _backend;
  final fb_auth.FirebaseAuth? _firebaseAuth;
  final GoogleSignIn? _googleSignIn;
  final FirebaseFirestore? _firestore;

  final Rxn<AppUser> _currentUser = Rxn<AppUser>();
  late final Future<void> _ready;

  AppUser? get currentUser => _currentUser.value;
  bool get isLoggedIn => _currentUser.value != null;
  bool get isManager =>
      _currentUser.value?.role == UserRole.admin || _currentUser.value?.role == UserRole.manager;
  bool get isStaffOnly => _currentUser.value?.role == UserRole.staff;
  bool get _useFirebase => _backend == BackendMode.firebase && _firebaseAuth != null;

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

  Future<bool> login(String username, String password, {bool staffLogin = false}) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (username.isEmpty || password.isEmpty) return false;
    if (staffLogin) {
      final staff = AppUser(
        id: 'u-staff',
        name: 'Karyawan',
        role: UserRole.staff,
        email: username,
        phone: '',
        address: '',
        region: '',
      );
      _currentUser.value = staff;
      await _persistLocalTokens(userId: null);
      _logs.add(
        title: 'Login karyawan',
        message: '$username masuk untuk tutup buku',
        actor: 'Karyawan',
      );
      return true;
    }

    if (_useFirebase) {
      final ok = await _loginViaFirebase(email: username, password: password);
      if (ok) return true;
    }

    final remoteOk = await _loginViaApi(username: username, password: password);
    if (remoteOk) return true;

    final found = await _userRepo.findByEmail(username);
    if (found == null) return false;
    if (found.password != password) return false;
    _setUser(found);
    await _persistSession(found.id);
    await _persistLocalTokens(userId: found.id);
    _logs.add(
      title: 'Login',
      message: '${found.name} masuk sebagai ${found.role.name}',
      actor: found.name,
    );
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

    if (_useFirebase) {
      final ok = await _loginGoogleViaFirebase(
        idToken: idToken,
        email: email,
        name: name,
        phone: phone,
        address: address,
        region: region,
      );
      return ok;
    }

    if (idToken != null && idToken.isNotEmpty) {
      final dto = await _loginGoogleViaApi(
        idToken: idToken,
        email: email,
        name: name,
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
        _logs.add(
          title: 'Login Google',
          message: '$email masuk lewat Google',
          actor: _currentUser.value?.name ?? 'User',
        );
        return true;
      }
    }

    final existing = await _userRepo.findByEmail(email);
    if (existing != null) {
      if (existing.role == UserRole.staff) {
        // Disallow Google login for staff accounts; they must use credentials provided by manager.
        return false;
      }
      final entity = existing
        ..phone = phone?.isNotEmpty == true ? phone! : existing.phone
        ..address = address?.isNotEmpty == true ? address! : existing.address
        ..region = region?.isNotEmpty == true ? region! : existing.region
        ..isGoogle = true;
      await _userRepo.upsert(entity);
      _setUser(entity);
      await _persistSession(entity.id);
    } else {
      final entity = UserEntity()
        ..name = name ?? email.split('@').first
        ..role = UserRole.manager
        ..email = email
        ..phone = phone ?? ''
        ..address = address ?? ''
        ..region = region ?? ''
        ..isGoogle = true;
      final savedId = await _userRepo.upsert(entity);
      entity.id = savedId;
      _setUser(entity);
      await _persistSession(entity.id);
      await _persistLocalTokens(userId: entity.id);
    }
    _logs.add(
      title: 'Login Google',
      message: '$email masuk lewat Google',
      actor: _currentUser.value?.name ?? 'User',
    );
    return true;
  }

  Future<bool> registerWithGoogle({
    String? idToken,
    required String email,
    String? name,
    required String phone,
    required String address,
    required String region,
  }) async {
    if (_useFirebase) {
      final ok = await _registerGoogleViaFirebase(
        idToken: idToken,
        email: email,
        name: name,
        phone: phone,
        address: address,
        region: region,
      );
      return ok;
    }

    if (idToken != null && idToken.isNotEmpty) {
      final dto = await _registerGoogleViaApi(
        idToken: idToken,
        email: email,
        name: name,
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
        _logs.add(
          title: 'Registrasi Google',
          message: '$email terdaftar melalui Google',
          actor: dto.user.name,
        );
        return true;
      }
    }

    final exists = await _userRepo.findByEmail(email);
    if (exists != null) return false;
    final entity = UserEntity()
      ..name = name ?? email.split('@').first
      ..role = UserRole.manager
      ..email = email
      ..phone = phone
      ..address = address
      ..region = region
      ..isGoogle = true;
    final savedId = await _userRepo.upsert(entity);
    entity.id = savedId;
    _setUser(entity);
    await _persistSession(entity.id);
    await _persistLocalTokens(userId: entity.id);
    _logs.add(
      title: 'Registrasi Google',
      message: '$email terdaftar melalui Google',
      actor: entity.name,
    );
    return true;
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

    if (_useFirebase) {
      final ok = await _registerViaFirebase(
        name: name,
        email: email,
        password: password,
        phone: phone,
        address: address,
        region: region,
        role: role,
      );
      return ok;
    }

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
      _logs.add(
        title: 'Registrasi akun',
        message: '$name mendaftar melalui API',
        actor: dto.user.name,
      );
      return true;
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
    _logs.add(
      title: 'Registrasi akun',
      message: '$name mendaftar dengan email $email',
      actor: name,
    );
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
    _logs.add(
      title: 'Permintaan reset password',
      message: 'Permintaan reset dikirim ke $email',
      actor: email,
    );
    return true;
  }

  Future<bool> resetPassword({required String email, required String newPassword}) async {
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
    _logs.add(
      title: 'Reset password',
      message: 'Password diperbarui untuk $email',
      actor: email,
      type: ActivityLogType.warning,
    );
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
    final firestore = _firestore;
    if (_useFirebase && firestore != null) {
      try {
        final uid = _firebaseAuth?.currentUser?.uid;
        if (uid != null) {
          await firestore.collection('users').doc(uid).set({
            'name': updated.name,
            'email': updated.email,
            'phone': updated.phone,
            'address': updated.address,
            'region': updated.region,
            'role': updated.role.name,
            'isGoogle': updated.isGoogle,
          }, SetOptions(merge: true));
        }
      } catch (_) {
        // ignore and keep local
      }
    }
    _logs.add(
      title: 'Perbarui profil',
      message: 'Profil diperbarui oleh ${updated.name}',
      actor: updated.name,
    );
    return true;
  }

  Future<bool> changePasswordForCurrent({required String newPassword, String? currentPassword}) async {
    final user = _currentUser.value;
    if (user == null) return false;
    if (user.password != null && !user.isGoogle) {
      if (currentPassword != null && currentPassword != user.password) return false;
    }
    return resetPassword(email: user.email, newPassword: newPassword);
  }

  Future<void> logout() async {
    if (_useFirebase) {
      await _firebaseAuth?.signOut();
      await _googleSignIn?.signOut();
    }
    if (_currentUser.value != null) {
      _logs.add(
        title: 'Logout',
        message: '${_currentUser.value!.name} keluar dari sesi',
        actor: _currentUser.value!.name,
      );
    }
    _currentUser.value = null;
    await _session.clear();
  }

  void _setUser(UserEntity user) {
    _currentUser.value = _fromEntity(user);
  }

  Future<void> _persistSession(int? userId) => _session.saveUserId(userId);

  Future<void> _persistAuthFromApi(AuthResponseDto dto, {String? fallbackPassword}) async {
    final entity = _toEntityFromDto(dto.user, fallbackPassword: fallbackPassword);
    final savedId = await _userRepo.upsert(entity);
    entity.id = savedId;
    _setUser(entity);
    await _session.saveUserId(entity.id);
    final now = DateTime.now();
    final token = dto.token.isNotEmpty ? dto.token : 'local-${entity.id}-${now.millisecondsSinceEpoch}';
    final refresh = dto.refreshToken.isNotEmpty ? dto.refreshToken : 'local-refresh-${entity.id}';
    await _session.saveToken(
      token: token,
      expiresAt: dto.expiresAt ?? now.add(const Duration(hours: 12)),
      userId: entity.id,
    );
    await _session.saveRefreshToken(refreshToken: refresh);
  }

  Future<void> _persistFromDto(AuthResponseDto dto, {String? fallbackPassword}) =>
      _persistAuthFromApi(dto, fallbackPassword: fallbackPassword);

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

  Future<bool> _loginViaApi({required String username, required String password}) async {
    try {
      final dto = await _remote.login(email: username, password: password);
      if (dto.token.isEmpty) return false;
      await _persistAuthFromApi(dto, fallbackPassword: password);
      _logs.add(
        title: 'Login',
        message: '${dto.user.name} masuk melalui API',
        actor: dto.user.name,
      );
      return true;
    } on DioException {
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _loginViaFirebase({required String email, required String password}) async {
    try {
      final cred = await _firebaseAuth?.signInWithEmailAndPassword(email: email, password: password);
      final user = cred?.user;
      if (user == null) return false;
      final entity = await _persistFromFirebaseUser(user);
      _setUser(entity);
      await _persistSession(entity.id);
      await _persistLocalTokens(userId: entity.id);
      _logs.add(
        title: 'Login',
        message: '${entity.name} masuk via Firebase',
        actor: entity.name,
      );
      return true;
    } catch (_) {
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

  Future<bool> _loginGoogleViaFirebase({
    String? idToken,
    required String email,
    String? name,
    String? phone,
    String? address,
    String? region,
  }) async {
    try {
      fb_auth.UserCredential cred;
      if (idToken != null && idToken.isNotEmpty) {
        final token = fb_auth.GoogleAuthProvider.credential(idToken: idToken);
        cred = await _firebaseAuth!.signInWithCredential(token);
      } else {
        final account = await (_googleSignIn ?? GoogleSignIn()).signIn();
        if (account == null) return false;
        final auth = await account.authentication;
        final credential = fb_auth.GoogleAuthProvider.credential(
          accessToken: auth.accessToken,
          idToken: auth.idToken,
        );
        cred = await _firebaseAuth!.signInWithCredential(credential);
      }
      final user = cred.user;
      if (user == null) return false;
      final entity = await _persistFromFirebaseUser(
        user,
        fallbackName: name,
        phone: phone,
        address: address,
        region: region,
      );
      _setUser(entity);
      await _persistSession(entity.id);
      await _persistLocalTokens(userId: entity.id);
      if (entity.role == UserRole.staff) {
        await logout();
        return false;
      }
      _logs.add(
        title: 'Login Google',
        message: '${entity.email} masuk via Firebase/Google',
        actor: entity.name,
      );
      return true;
    } catch (_) {
      return false;
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
      return dto.token.isEmpty ? null : dto;
    } catch (_) {
      return null;
    }
  }

  Future<bool> _registerGoogleViaFirebase({
    String? idToken,
    required String email,
    String? name,
    String? phone,
    String? address,
    String? region,
  }) async {
    try {
      // FirebaseAuth does not support "register Google" separately; we just sign in.
      final ok = await _loginGoogleViaFirebase(
        idToken: idToken,
        email: email,
        name: name,
        phone: phone,
        address: address,
        region: region,
      );
      if (!ok) return false;
      _logs.add(
        title: 'Registrasi Google',
        message: '$email terdaftar via Firebase/Google',
        actor: _currentUser.value?.name ?? email,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _registerViaFirebase({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
    required String region,
    required UserRole role,
  }) async {
    try {
      final cred = await _firebaseAuth?.createUserWithEmailAndPassword(email: email, password: password);
      final user = cred?.user;
      if (user == null) return false;
      await user.updateDisplayName(name);
      final entity = await _persistFromFirebaseUser(
        user,
        overrideRole: role,
        phone: phone,
        address: address,
        region: region,
      );
      _setUser(entity);
      await _persistSession(entity.id);
      await _persistLocalTokens(userId: entity.id);
      _logs.add(
        title: 'Registrasi akun',
        message: '$name mendaftar via Firebase',
        actor: name,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<UserEntity> _persistFromFirebaseUser(
    fb_auth.User user, {
    String? fallbackName,
    String? phone,
    String? address,
    String? region,
    UserRole? overrideRole,
  }) async {
    UserRole role = overrideRole ?? UserRole.manager;
    String name = user.displayName ?? fallbackName ?? user.email?.split('@').first ?? 'User';
    String email = user.email ?? '${user.uid}@firebase.local';
    String phoneVal = phone ?? user.phoneNumber ?? '';
    String addressVal = address ?? '';
    String regionVal = region ?? '';
    final existing = await _userRepo.findByEmail(email);

    try {
      final firestore = _firestore;
      if (firestore != null) {
        final doc = await firestore.collection('users').doc(user.uid).get();
        final data = doc.data();
        if (data != null) {
          name = data['name']?.toString() ?? name;
          email = data['email']?.toString() ?? email;
          phoneVal = data['phone']?.toString() ?? phoneVal;
          addressVal = data['address']?.toString() ?? addressVal;
          regionVal = data['region']?.toString() ?? regionVal;
          role = _roleFromString(data['role']?.toString() ?? role.name);
        } else {
          await firestore.collection('users').doc(user.uid).set({
            'name': name,
            'email': email,
            'phone': phoneVal,
            'address': addressVal,
            'region': regionVal,
            'role': role.name,
            'isGoogle': user.providerData.any((p) => p.providerId == 'google.com'),
          });
        }
      }
    } catch (_) {
      // ignore firestore failures, use local data
    }

    final entity = UserEntity()
      ..name = name
      ..role = role
      ..email = email
      ..phone = phoneVal
      ..address = addressVal
      ..region = regionVal
      ..isGoogle = user.providerData.any((p) => p.providerId == 'google.com')
      ..password = null;
    if (existing != null) {
      entity.id = existing.id;
    }
    final savedId = await _userRepo.upsert(entity);
    entity.id = savedId;
    final token = await user.getIdToken();
    await _session.saveToken(
      token: token ?? 'firebase-${entity.id}',
      expiresAt: DateTime.now().add(const Duration(hours: 1)),
      userId: entity.id,
    );
    await _session.saveRefreshToken(refreshToken: 'firebase-refresh-${entity.id}');
    return entity;
  }
}
