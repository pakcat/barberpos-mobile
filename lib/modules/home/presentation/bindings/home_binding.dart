import 'package:get/get.dart';

import '../../../../core/network/network_service.dart';
import '../../data/datasources/home_remote_data_source.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/usecases/get_welcome_message.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    HomeRemoteDataSource remote = HomeRemoteDataSourceImpl(Get.find<NetworkService>().dio);

    Get.lazyPut<HomeRepository>(() => HomeRepositoryImpl(remote));
    Get.lazyPut<GetWelcomeMessageUseCase>(() => GetWelcomeMessageUseCase(Get.find<HomeRepository>()));
    Get.lazyPut<HomeController>(
      () => HomeController(getWelcomeMessage: Get.find<GetWelcomeMessageUseCase>()),
    );
  }
}
