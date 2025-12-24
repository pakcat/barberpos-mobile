import 'dart:async';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';

import 'settings_controller.dart';

class BluetoothPrinterController extends GetxController {
  BluetoothPrinterController({
    SettingsController? settings,
    FlutterBluetoothSerial? bluetooth,
  }) : _settings = settings ?? Get.find<SettingsController>(),
       _bluetooth = bluetooth ?? FlutterBluetoothSerial.instance;

  final SettingsController _settings;
  final FlutterBluetoothSerial _bluetooth;

  final loading = false.obs;
  final enabling = false.obs;
  final RxBool enabled = false.obs;
  final RxList<BluetoothDevice> bondedDevices = <BluetoothDevice>[].obs;

  String get selectedMac => _settings.printerMacController.text.trim();

  @override
  void onInit() {
    super.onInit();
    unawaited(loadDevices());
  }

  Future<void> loadDevices() async {
    loading.value = true;
    try {
      final isEnabled = await _bluetooth.isEnabled;
      enabled.value = isEnabled == true;

      if (enabled.value) {
        final bonded = await _bluetooth.getBondedDevices();
        bondedDevices.assignAll(bonded);
      } else {
        bondedDevices.clear();
      }
    } finally {
      loading.value = false;
    }
  }

  Future<void> requestEnable() async {
    if (enabling.value) return;
    enabling.value = true;
    try {
      await _bluetooth.requestEnable();
    } finally {
      enabling.value = false;
      await loadDevices();
    }
  }

  Future<void> openBluetoothSettings() async {
    try {
      await _bluetooth.openSettings();
    } finally {
      await loadDevices();
    }
  }

  Future<void> selectDevice(BluetoothDevice device) async {
    if (device.address.isEmpty) {
      Get.snackbar('Gagal', 'Alamat perangkat tidak valid');
      return;
    }
    _settings.printerMacController.text = device.address;
    _settings.printerMac.value = device.address;

    if ((_settings.printerNameController.text).trim().isEmpty) {
      _settings.printerNameController.text = device.name?.trim().isNotEmpty == true
          ? device.name!.trim()
          : 'Printer Bluetooth';
      _settings.printerName.value = _settings.printerNameController.text;
    }

    Get.snackbar('Bluetooth', 'Printer dipilih: ${device.name ?? device.address}');
  }
}
