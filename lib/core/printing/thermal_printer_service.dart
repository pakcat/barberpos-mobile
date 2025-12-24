import 'dart:typed_data';

import 'package:get/get.dart';

import '../../modules/settings/domain/entities/settings_profile.dart';
import '../../modules/settings/domain/repositories/settings_repository.dart';
import '../../modules/transactions/presentation/models/transaction_models.dart';
import 'escpos/escpos_printer.dart';
import 'escpos/escpos_receipt.dart';

class ThermalPrinterService {
  ThermalPrinterService({SettingsRepository? settings})
    : _settings = settings ?? (Get.isRegistered<SettingsRepository>() ? Get.find<SettingsRepository>() : null);

  final SettingsRepository? _settings;

  Future<void> testPrint() async {
    final profile = await loadProfile();
    _validateOrThrow(profile);
    final type = EscPosPrinter.parseType(profile.printerType);
    if (type == ThermalPrinterType.lan) {
      await EscPosPrinter.testLan(host: profile.printerHost, port: profile.printerPort);
    }
    final dummy = TransactionItem(
      id: 'TEST-${DateTime.now().millisecondsSinceEpoch}',
      date: DateTime.now(),
      time: '',
      amount: 15000,
      paymentMethod: 'Tunai',
      status: TransactionStatus.paid,
      items: const [
        TransactionLine(name: 'Test Print', category: 'System', price: 15000, qty: 1),
      ],
      customer: const TransactionCustomer(name: '', phone: '', email: '', address: ''),
    );
    await printReceipt(dummy, profile: profile);
  }

  Future<void> printReceipt(TransactionItem tx, {SettingsProfile? profile}) async {
    final p = profile ?? await loadProfile();
    _validateOrThrow(p);
    final type = EscPosPrinter.parseType(p.printerType);

    final bytes = await EscPosReceipt.build(
      tx,
      businessName: p.businessName,
      businessPhone: p.businessPhone,
      businessAddress: p.businessAddress,
      receiptFooter: p.receiptFooter,
      paperSize: p.paperSize,
    );

    await _send(type: type, profile: p, bytes: bytes);
  }

  void _validateOrThrow(SettingsProfile p) {
    if (p.paperSize == 'A4') {
      throw UnsupportedError('Paper size A4 gunakan menu Print (PDF) saja');
    }
    final type = EscPosPrinter.parseType(p.printerType);
    if (type == ThermalPrinterType.system) {
      throw UnsupportedError('Tipe printer masih "system". Pilih LAN/Bluetooth untuk thermal.');
    }
    if (type == ThermalPrinterType.lan) {
      if (p.printerHost.trim().isEmpty) {
        throw ArgumentError('Printer LAN: IP/Host wajib diisi');
      }
      if (p.printerPort <= 0) {
        throw ArgumentError('Printer LAN: port tidak valid');
      }
    }
    if (type == ThermalPrinterType.bluetooth) {
      if (p.printerMac.trim().isEmpty) {
        throw ArgumentError('Printer Bluetooth: MAC address wajib diisi');
      }
    }
  }

  Future<void> _send({
    required ThermalPrinterType type,
    required SettingsProfile profile,
    required Uint8List bytes,
  }) async {
    switch (type) {
      case ThermalPrinterType.lan:
        await EscPosPrinter.printViaLan(
          host: profile.printerHost,
          port: profile.printerPort,
          bytes: bytes,
        );
        return;
      case ThermalPrinterType.bluetooth:
        await EscPosPrinter.printViaBluetooth(
          macAddress: profile.printerMac,
          bytes: bytes,
        );
        return;
      case ThermalPrinterType.system:
        throw UnsupportedError('PrinterType system tidak mendukung ESC/POS');
    }
  }

  Future<SettingsProfile> loadProfile() async {
    final repo = _settings;
    if (repo == null) {
      return SettingsProfile.defaults();
    }
    return repo.load();
  }
}
