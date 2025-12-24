import '../entities/settings_entity.dart';
import '../../domain/entities/settings_profile.dart';

class SettingsDto {
  SettingsDto({
    required this.businessName,
    required this.businessAddress,
    required this.businessPhone,
    required this.receiptFooter,
    required this.defaultPaymentMethod,
    required this.printerName,
    required this.printerType,
    required this.printerHost,
    required this.printerPort,
    required this.printerMac,
    required this.paperSize,
    required this.autoPrint,
    required this.notifications,
    required this.trackStock,
    required this.roundingPrice,
    required this.autoBackup,
    required this.cashierPin,
  });

  final String businessName;
  final String businessAddress;
  final String businessPhone;
  final String receiptFooter;
  final String defaultPaymentMethod;
  final String printerName;
  final String printerType;
  final String printerHost;
  final int printerPort;
  final String printerMac;
  final String paperSize;
  final bool autoPrint;
  final bool notifications;
  final bool trackStock;
  final bool roundingPrice;
  final bool autoBackup;
  final bool cashierPin;

  factory SettingsDto.fromJson(Map<String, dynamic> json) {
    return SettingsDto(
      businessName: json['businessName']?.toString() ?? '',
      businessAddress: json['businessAddress']?.toString() ?? '',
      businessPhone: json['businessPhone']?.toString() ?? '',
      receiptFooter: json['receiptFooter']?.toString() ?? '',
      defaultPaymentMethod: json['defaultPaymentMethod']?.toString() ?? '',
      printerName: json['printerName']?.toString() ?? '',
      printerType: json['printerType']?.toString() ?? 'system',
      printerHost: json['printerHost']?.toString() ?? '',
      printerPort: int.tryParse(json['printerPort']?.toString() ?? '') ?? 9100,
      printerMac: json['printerMac']?.toString() ?? '',
      paperSize: json['paperSize']?.toString() ?? '',
      autoPrint: json['autoPrint'] == true,
      notifications: json['notifications'] != false,
      trackStock: json['trackStock'] == true,
      roundingPrice: json['roundingPrice'] == true,
      autoBackup: json['autoBackup'] != false,
      cashierPin: json['cashierPin'] == true,
    );
  }

  SettingsEntity toEntity() {
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
    ).toEntity();
  }
}
