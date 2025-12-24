import 'package:get/get.dart';

import '../../../../core/network/network_service.dart';
import '../../../dashboard/presentation/controllers/dashboard_controller.dart';
import '../../data/datasources/home_remote_data_source.dart';
import '../../data/repositories/home_repository_impl.dart';
import '../../domain/repositories/home_repository.dart';
import '../../domain/usecases/get_welcome_message.dart';
import '../controllers/home_controller.dart';
import '../../../transactions/presentation/controllers/transaction_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    HomeRemoteDataSource remote = HomeRemoteDataSourceImpl(Get.find<NetworkService>().dio);

    Get.lazyPut<HomeRepository>(() => HomeRepositoryImpl(remote));
    Get.lazyPut<GetWelcomeMessageUseCase>(() => GetWelcomeMessageUseCase(Get.find<HomeRepository>()));
    Get.lazyPut<HomeController>(
      () => HomeController(getWelcomeMessage: Get.find<GetWelcomeMessageUseCase>()),
    );

    // Home screen widgets depend on these controllers; register once here (instead of in build()).
    Get.lazyPut<DashboardController>(() => DashboardController(), fenix: true);
    Get.lazyPut<TransactionController>(() => TransactionController(), fenix: true);
  }
}
