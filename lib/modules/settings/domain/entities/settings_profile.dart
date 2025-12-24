class SettingsProfile {
  SettingsProfile({
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

  SettingsProfile copyWith({
    String? businessName,
    String? businessAddress,
    String? businessPhone,
    String? receiptFooter,
    String? defaultPaymentMethod,
    String? printerName,
    String? printerType,
    String? printerHost,
    int? printerPort,
    String? printerMac,
    String? paperSize,
    bool? autoPrint,
    bool? notifications,
    bool? trackStock,
    bool? roundingPrice,
    bool? autoBackup,
    bool? cashierPin,
  }) {
    return SettingsProfile(
      businessName: businessName ?? this.businessName,
      businessAddress: businessAddress ?? this.businessAddress,
      businessPhone: businessPhone ?? this.businessPhone,
      receiptFooter: receiptFooter ?? this.receiptFooter,
      defaultPaymentMethod: defaultPaymentMethod ?? this.defaultPaymentMethod,
      printerName: printerName ?? this.printerName,
      printerType: printerType ?? this.printerType,
      printerHost: printerHost ?? this.printerHost,
      printerPort: printerPort ?? this.printerPort,
      printerMac: printerMac ?? this.printerMac,
      paperSize: paperSize ?? this.paperSize,
      autoPrint: autoPrint ?? this.autoPrint,
      notifications: notifications ?? this.notifications,
      trackStock: trackStock ?? this.trackStock,
      roundingPrice: roundingPrice ?? this.roundingPrice,
      autoBackup: autoBackup ?? this.autoBackup,
      cashierPin: cashierPin ?? this.cashierPin,
    );
  }

  static SettingsProfile defaults() {
    return SettingsProfile(
      businessName: 'Barber POS',
      businessAddress: 'Jl. Mawar No. 12, Bandung',
      businessPhone: '0812-3456-7890',
      receiptFooter: 'Terima kasih sudah berkunjung!',
      defaultPaymentMethod: 'Tunai',
      printerName: 'Printer Kasir #1',
      printerType: 'system',
      printerHost: '',
      printerPort: 9100,
      printerMac: '',
      paperSize: '58mm',
      autoPrint: true,
      notifications: true,
      trackStock: true,
      roundingPrice: false,
      autoBackup: true,
      cashierPin: false,
    );
  }
}
