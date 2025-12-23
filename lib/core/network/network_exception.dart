import 'package:dio/dio.dart';

class NetworkException implements Exception {
  NetworkException(this.message);

  final String message;

  @override
  String toString() => message;

  factory NetworkException.fromDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timed out. Please try again.');
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        return NetworkException('Server error${statusCode != null ? ' ($statusCode)' : ''}.');
      case DioExceptionType.cancel:
        return NetworkException('Request was cancelled.');
      case DioExceptionType.connectionError:
        return NetworkException('Could not connect to server.');
      default:
        return NetworkException(error.message ?? 'Unexpected network error.');
    }
  }
}
