import 'package:dio/dio.dart';

import '../services/session_service.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._session);

  final SessionService _session;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _session.loadToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}
