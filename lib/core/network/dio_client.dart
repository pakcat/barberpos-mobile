import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../config/app_config.dart';
import '../services/session_service.dart';
import 'auth_interceptor.dart';
import 'refresh_token_interceptor.dart';
import 'response_envelope_interceptor.dart';

Dio buildDioClient(AppConfig config, {SessionService? session}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: config.baseUrl,
      connectTimeout: config.connectTimeout,
      receiveTimeout: config.receiveTimeout,
      sendTimeout: config.sendTimeout,
    ),
  );

  if (!kReleaseMode) {
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
        compact: true,
        maxWidth: 120,
      ),
    );
  }
  dio.interceptors.add(ResponseEnvelopeInterceptor());
  if (session != null) {
    dio.interceptors.add(AuthInterceptor(session));
    dio.interceptors.add(RefreshTokenInterceptor(session: session, baseUrl: config.baseUrl));
  }

  return dio;
}
