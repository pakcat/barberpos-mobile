import 'package:dio/dio.dart';

import '../services/session_service.dart';
import 'response_envelope_interceptor.dart';

class RefreshTokenInterceptor extends Interceptor {
  RefreshTokenInterceptor({
    required this.session,
    required this.baseUrl,
    this.refreshPath = '/auth/refresh',
  }) : _refreshDio = Dio(BaseOptions(baseUrl: baseUrl))
         ..interceptors.add(ResponseEnvelopeInterceptor());

  final SessionService session;
  final String baseUrl;
  final String refreshPath;
  final Dio _refreshDio;

  bool _refreshing = false;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final request = err.requestOptions;
    final status = err.response?.statusCode;
    final isRefreshCall = request.path.contains(refreshPath);

    if (status != 401 ||
        isRefreshCall ||
        request.extra['skipRefresh'] == true) {
      return super.onError(err, handler);
    }

    if (_refreshing) {
      // If already refreshing, just forward the error and let a subsequent retry handle it.
      return super.onError(err, handler);
    }

    final refreshToken = await session.loadRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      final token = await session.loadToken();
      if (token != null && token.isNotEmpty) {
        await session.clear();
      }
      return super.onError(err, handler);
    }

    try {
      _refreshing = true;
      final refreshRes = await _refreshDio.post<Map<String, dynamic>>(
        refreshPath,
        data: {'refreshToken': refreshToken},
        options: Options(
          headers: {'Authorization': 'Bearer $refreshToken'},
          extra: {'skipRefresh': true},
        ),
      );
      final data = refreshRes.data ?? {};
      final newToken = data['token']?.toString();
      final newRefresh = data['refreshToken']?.toString() ?? refreshToken;
      if (newToken == null || newToken.isEmpty) {
        return super.onError(err, handler);
      }
      await session.saveToken(
        token: newToken,
        expiresAt: DateTime.now().add(const Duration(hours: 1)),
      );
      await session.saveRefreshToken(refreshToken: newRefresh);

      final cloned = await _retry(request, newToken);
      return handler.resolve(cloned);
    } catch (_) {
      await session.clear();
      return super.onError(err, handler);
    } finally {
      _refreshing = false;
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions request, String token) {
    final dio = Dio(BaseOptions(baseUrl: baseUrl))
      ..interceptors.add(ResponseEnvelopeInterceptor());
    final options = Options(
      method: request.method,
      headers: Map<String, dynamic>.from(request.headers)
        ..['Authorization'] = 'Bearer $token',
      extra: Map<String, dynamic>.from(request.extra)..['skipRefresh'] = true,
      responseType: request.responseType,
      contentType: request.contentType,
    );
    return dio.request<dynamic>(
      request.path,
      data: request.data,
      queryParameters: request.queryParameters,
      options: options,
    );
  }
}
