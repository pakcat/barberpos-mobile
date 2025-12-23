import 'package:barberpos_mobile/modules/auth/data/datasources/auth_remote_data_source.dart';
import 'package:barberpos_mobile/modules/auth/data/models/auth_models.dart';
import 'package:dio/dio.dart';

class StubAuthRemoteDataSource extends AuthRemoteDataSource {
  StubAuthRemoteDataSource() : super(Dio());

  @override
  Future<AuthResponseDto> login({required String email, required String password}) async {
    throw DioException(requestOptions: RequestOptions(path: '/auth/login'));
  }

  @override
  Future<AuthResponseDto> loginWithGoogle({
    required String idToken,
    required String email,
    String? name,
    String? phone,
    String? address,
    String? region,
  }) async {
    throw DioException(requestOptions: RequestOptions(path: '/auth/google'));
  }

  @override
  Future<AuthResponseDto> registerWithEmail({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
    required String region,
    String role = 'manager',
  }) async {
    throw DioException(requestOptions: RequestOptions(path: '/auth/register'));
  }

  @override
  Future<void> requestReset(String email) async {
    throw DioException(requestOptions: RequestOptions(path: '/auth/forgot-password'));
  }

  @override
  Future<void> resetPassword({required String token, required String password}) async {
    throw DioException(requestOptions: RequestOptions(path: '/auth/reset-password'));
  }

  @override
  Future<AuthResponseDto> refreshToken(String refreshToken) async {
    throw DioException(requestOptions: RequestOptions(path: '/auth/refresh'));
  }
}
