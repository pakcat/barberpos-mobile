import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';

// Bluetooth SPP (Android) for many thermal printers.
// This plugin is platform-specific; calls are guarded by runtime checks.
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

enum ThermalPrinterType { system, lan, bluetooth }

class EscPosPrinter {
  EscPosPrinter._();

  static ThermalPrinterType parseType(String raw) {
    switch (raw.trim().toLowerCase()) {
      case 'lan':
        return ThermalPrinterType.lan;
      case 'bluetooth':
        return ThermalPrinterType.bluetooth;
      case 'system':
      default:
        return ThermalPrinterType.system;
    }
  }

  static Future<void> printViaLan({
    required String host,
    required int port,
    required Uint8List bytes,
    Duration timeout = const Duration(seconds: 8),
  }) async {
    if (host.trim().isEmpty) {
      throw ArgumentError('printerHost is empty');
    }
    if (port <= 0) {
      throw ArgumentError('printerPort is invalid');
    }

    final socket = await Socket.connect(host.trim(), port, timeout: timeout);
    try {
      socket.add(bytes);
      await socket.flush();
    } finally {
      socket.destroy();
    }
  }

  static Future<void> testLan({
    required String host,
    required int port,
    Duration timeout = const Duration(seconds: 3),
  }) async {
    final socket = await Socket.connect(host.trim(), port, timeout: timeout);
    socket.destroy();
  }

  static Future<void> printViaBluetooth({
    required String macAddress,
    required Uint8List bytes,
    Duration timeout = const Duration(seconds: 12),
  }) async {
    if (kIsWeb) {
      throw UnsupportedError('Bluetooth printing is not supported on web');
    }
    if (!Platform.isAndroid) {
      throw UnsupportedError('Bluetooth printing is only implemented for Android');
    }
    if (macAddress.trim().isEmpty) {
      throw ArgumentError('printerMac is empty');
    }

    BluetoothConnection? connection;
    try {
      final enabled = await FlutterBluetoothSerial.instance.isEnabled;
      if (enabled != true) {
        throw StateError('Bluetooth belum aktif. Aktifkan Bluetooth lalu coba lagi.');
      }
      connection = await BluetoothConnection.toAddress(macAddress.trim()).timeout(timeout);
      connection.output.add(bytes);
      await connection.output.allSent;
    } finally {
      await connection?.finish();
    }
  }
}
