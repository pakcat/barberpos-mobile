import 'package:dio/dio.dart';

/// Unwraps backend standard envelope:
/// `{ "status": "...", "message": "...", "data": ... }`
///
/// This keeps existing data sources working (they can keep reading `response.data`
/// as a List/Map), while the logger still prints the full envelope if this
/// interceptor is added before the logger (so it runs after it on responses).
class ResponseEnvelopeInterceptor extends Interceptor {
  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    final body = response.data;
    if (body is Map) {
      final hasStatus = body.containsKey('status');
      final hasData = body.containsKey('data');
      if (hasStatus && hasData) {
        response.data = body['data'];
      }
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final body = err.response?.data;
    if (body is Map && body['message'] is String) {
      err = err.copyWith(message: body['message'] as String);
    }
    handler.next(err);
  }
}

