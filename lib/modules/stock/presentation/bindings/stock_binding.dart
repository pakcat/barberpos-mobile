import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/database/local_database.dart';
import '../../../../core/network/network_service.dart';
import '../../../../core/config/app_config.dart';
import '../../data/repositories/stock_repository.dart';
import '../../data/datasources/stock_remote_data_source.dart';
import '../../data/datasources/stock_firestore_data_source.dart';
import '../controllers/stock_controller.dart';

class StockBinding extends Bindings {
  @override
  void dependencies() {
    final config = Get.find<AppConfig>();
    if (!Get.isRegistered<StockRepository>()) {
      Get.put<StockRepository>(
        StockRepository(
          Get.find<LocalDatabase>().isar,
          restRemote: config.backend == BackendMode.rest
              ? StockRemoteDataSource(Get.find<NetworkService>().dio)
              : null,
          remote: config.backend == BackendMode.firebase
              ? StockFirestoreDataSource(FirebaseFirestore.instance)
              : null,
        ),
        permanent: true,
      );
    }
    Get.lazyPut<StockController>(() => StockController());
  }
}
