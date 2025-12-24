import 'package:dio/dio.dart';

import '../models/auth_models.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dio);

  final Dio _dio;

  Future<AuthResponseDto> login({
    required String email,
    required String password,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    return AuthResponseDto.fromJson(res.data ?? <String, dynamic>{});
  }

  Future<AuthResponseDto> loginStaff({
    String? phone,
    String? email,
    required String pin,
    String? name,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/auth/staff',
      data: {
        if (phone != null && phone.isNotEmpty) 'phone': phone,
        if (email != null && email.isNotEmpty) 'email': email,
        'pin': pin,
        if (name != null) 'name': name,
      },
    );
    return AuthResponseDto.fromJson(res.data ?? <String, dynamic>{});
  }

  Future<AuthResponseDto> loginWithGoogle({
    required String idToken,
    required String email,
    String? name,
    String? phone,
    String? address,
    String? region,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/auth/google',
      data: {
        'idToken': idToken,
        'email': email,
        'name': name,
        'phone': phone,
        'address': address,
        'region': region,
      },
    );
    return AuthResponseDto.fromJson(res.data ?? <String, dynamic>{});
  }

  Future<AuthResponseDto> registerWithEmail({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
    required String region,
    String role = 'manager',
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/auth/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
        'address': address,
        'region': region,
        'role': role,
      },
    );
    return AuthResponseDto.fromJson(res.data ?? <String, dynamic>{});
  }

  Future<void> requestReset(String email) async {
    await _dio.post('/auth/forgot-password', data: {'email': email});
  }

  Future<void> resetPassword({
    required String token,
    required String password,
  }) async {
    await _dio.post(
      '/auth/reset-password',
      data: {'token': token, 'password': password},
    );
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _dio.post(
      '/auth/change-password',
      data: {'currentPassword': currentPassword, 'newPassword': newPassword},
    );
  }

  Future<AuthResponseDto> refreshToken(String refreshToken) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/auth/refresh',
      data: {'refreshToken': refreshToken},
      options: Options(extra: {'skipRefresh': true}),
    );
    return AuthResponseDto.fromJson(res.data ?? <String, dynamic>{});
  }
}
