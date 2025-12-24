import 'package:get/get.dart';

import 'settings_binding.dart';
import '../controllers/settings_controller.dart';
import '../controllers/bluetooth_printer_controller.dart';

class BluetoothPrinterBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<SettingsController>()) {
      SettingsBinding().dependencies();
    }
    Get.lazyPut<BluetoothPrinterController>(() => BluetoothPrinterController());
  }
}
