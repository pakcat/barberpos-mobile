import 'package:get/get.dart';

import '../../../../core/config/app_config.dart';
import '../controllers/product_controller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    final config = Get.find<AppConfig>();
    Get.lazyPut<ProductController>(() => ProductController(config: config));
  }
}
