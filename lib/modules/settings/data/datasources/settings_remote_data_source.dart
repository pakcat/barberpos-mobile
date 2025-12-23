import 'package:dio/dio.dart';

import '../../domain/entities/settings_profile.dart';

class SettingsRemoteDataSource {
  SettingsRemoteDataSource(this._dio);

  final Dio _dio;

  Future<SettingsProfile?> load() async {
    final res = await _dio.get<Map<String, dynamic>>('/settings');
    final data = res.data;
    if (data == null) return null;
    return _toProfile(data);
  }

  Future<void> save(SettingsProfile profile) async {
    await _dio.put<Map<String, dynamic>>(
      '/settings',
      data: {
        'businessName': profile.businessName,
        'businessAddress': profile.businessAddress,
        'businessPhone': profile.businessPhone,
        'receiptFooter': profile.receiptFooter,
        'defaultPaymentMethod': profile.defaultPaymentMethod,
        'printerName': profile.printerName,
        'paperSize': profile.paperSize,
        'autoPrint': profile.autoPrint,
        'notifications': profile.notifications,
        'trackStock': profile.trackStock,
        'roundingPrice': profile.roundingPrice,
        'autoBackup': profile.autoBackup,
        'cashierPin': profile.cashierPin,
      },
    );
  }

  SettingsProfile _toProfile(Map<String, dynamic> data) {
    return SettingsProfile(
      businessName: data['businessName']?.toString() ?? '',
      businessAddress: data['businessAddress']?.toString() ?? '',
      businessPhone: data['businessPhone']?.toString() ?? '',
      receiptFooter: data['receiptFooter']?.toString() ?? '',
      defaultPaymentMethod: data['defaultPaymentMethod']?.toString() ?? '',
      printerName: data['printerName']?.toString() ?? '',
      paperSize: data['paperSize']?.toString() ?? '',
      autoPrint: data['autoPrint'] == true,
      notifications: data['notifications'] != false,
      trackStock: data['trackStock'] == true,
      roundingPrice: data['roundingPrice'] == true,
      autoBackup: data['autoBackup'] == true,
      cashierPin: data['cashierPin'] == true,
    );
  }
}
