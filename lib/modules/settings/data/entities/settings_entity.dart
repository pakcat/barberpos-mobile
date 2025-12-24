import 'package:isar_community/isar.dart';

import '../../domain/entities/settings_profile.dart';

part 'settings_entity.g.dart';

@collection
class SettingsEntity {
  Id id = 1; // single row
  late String businessName;
  late String businessAddress;
  late String businessPhone;
  late String receiptFooter;
  late String defaultPaymentMethod;
  late String printerName;
  late String printerType;
  late String printerHost;
  late int printerPort;
  late String printerMac;
  late String paperSize;
  late bool autoPrint;
  late bool notifications;
  late bool trackStock;
  late bool roundingPrice;
  late bool autoBackup;
  late bool cashierPin;
}

extension SettingsEntityMapper on SettingsEntity {
  SettingsProfile toDomain() {
    return SettingsProfile(
      businessName: businessName,
      businessAddress: businessAddress,
      businessPhone: businessPhone,
      receiptFooter: receiptFooter,
      defaultPaymentMethod: defaultPaymentMethod,
      printerName: printerName,
      printerType: printerType,
      printerHost: printerHost,
      printerPort: printerPort,
      printerMac: printerMac,
      paperSize: paperSize,
      autoPrint: autoPrint,
      notifications: notifications,
      trackStock: trackStock,
      roundingPrice: roundingPrice,
      autoBackup: autoBackup,
      cashierPin: cashierPin,
    );
  }
}

extension SettingsProfileMapper on SettingsProfile {
  SettingsEntity toEntity() {
    return SettingsEntity()
      ..id = 1
      ..businessName = businessName
      ..businessAddress = businessAddress
      ..businessPhone = businessPhone
      ..receiptFooter = receiptFooter
      ..defaultPaymentMethod = defaultPaymentMethod
      ..printerName = printerName
      ..printerType = printerType
      ..printerHost = printerHost
      ..printerPort = printerPort
      ..printerMac = printerMac
      ..paperSize = paperSize
      ..autoPrint = autoPrint
      ..notifications = notifications
      ..trackStock = trackStock
      ..roundingPrice = roundingPrice
      ..autoBackup = autoBackup
      ..cashierPin = cashierPin;
  }
}

