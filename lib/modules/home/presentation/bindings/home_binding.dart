import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/network_service.dart';
import '../../data/datasources/home_firestore_data_source.dart';
import '../../data/datasources/home_remote_data_source.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/usecases/get_welcome_message.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    final config = Get.find<AppConfig>();
    HomeRemoteDataSource? remote;
    if (config.backend == BackendMode.rest) {
      remote = HomeRemoteDataSourceImpl(Get.find<NetworkService>().dio);
    }

    HomeFirestoreDataSource? firebase;
    if (config.backend == BackendMode.firebase) {
      firebase = HomeFirestoreDataSource(FirebaseFirestore.instance);
    }

    Get.lazyPut<HomeRemoteDataSource?>(
      () => remote,
    );

    Get.lazyPut<HomeRepository>(
      () => HomeRepositoryImpl(
        remote ?? HomeRemoteDataSourceImpl(Get.find<NetworkService>().dio),
        firebase: firebase,
      ),
    );

    Get.lazyPut<GetWelcomeMessageUseCase>(
      () => GetWelcomeMessageUseCase(Get.find<HomeRepository>()),
    );

    Get.lazyPut<HomeController>(
      () => HomeController(getWelcomeMessage: Get.find<GetWelcomeMessageUseCase>()),
    );
  }
}
