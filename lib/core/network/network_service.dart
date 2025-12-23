import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../config/app_config.dart';
import '../services/session_service.dart';
import 'dio_client.dart';

/// Central place to build and expose a configured Dio client.
class NetworkService extends GetxService {
  NetworkService({
    required AppConfig config,
    required SessionService session,
  }) : dio = buildDioClient(config, session: session);

  final Dio dio;
}
