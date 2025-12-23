import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/database/local_database.dart';
import '../../data/datasources/product_firestore_data_source.dart';
import '../../data/repositories/product_repository.dart';
import '../controllers/product_controller.dart';
import '../../../management/data/datasources/category_firestore_data_source.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    final config = Get.find<AppConfig>();
    Get.lazyPut<ProductRepository>(() => ProductRepository(Get.find<LocalDatabase>().isar));
    Get.lazyPut<ProductController>(
      () => ProductController(
        firebase: config.backend == BackendMode.firebase
            ? ProductFirestoreDataSource(FirebaseFirestore.instance)
            : null,
        categoryFirebase: config.backend == BackendMode.firebase
            ? CategoryFirestoreDataSource(FirebaseFirestore.instance)
            : null,
        config: config,
      ),
    );
  }
}
