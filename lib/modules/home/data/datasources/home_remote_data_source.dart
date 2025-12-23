import 'package:dio/dio.dart';

import '../../../../core/network/network_exception.dart';
import '../models/welcome_dto.dart';

abstract class HomeRemoteDataSource {
  Future<WelcomeDto> fetchWelcomeMessage();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  HomeRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<WelcomeDto> fetchWelcomeMessage() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/posts/1');
      final data = response.data ?? <String, dynamic>{};
      return WelcomeDto.fromJson(data);
    } on DioException catch (error) {
      throw NetworkException.fromDioError(error);
    }
  }
}
