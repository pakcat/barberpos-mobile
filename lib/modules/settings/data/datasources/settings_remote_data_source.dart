import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

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
        'printerType': profile.printerType,
        'printerHost': profile.printerHost,
        'printerPort': profile.printerPort,
        'printerMac': profile.printerMac,
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
      printerType: data['printerType']?.toString() ?? 'system',
      printerHost: data['printerHost']?.toString() ?? '',
      printerPort: int.tryParse(data['printerPort']?.toString() ?? '') ?? 9100,
      printerMac: data['printerMac']?.toString() ?? '',
      paperSize: data['paperSize']?.toString() ?? '',
      autoPrint: data['autoPrint'] == true,
      notifications: data['notifications'] != false,
      trackStock: data['trackStock'] == true,
      roundingPrice: data['roundingPrice'] == true,
      autoBackup: data['autoBackup'] == true,
      cashierPin: data['cashierPin'] == true,
    );
  }

  Future<Uint8List?> loadQrisImage() async {
    try {
      final res = await _dio.get<List<int>>(
        '/settings/qris',
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = res.data ?? <int>[];
      if (bytes.isEmpty) return null;
      return Uint8List.fromList(bytes);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  Future<void> saveQrisImage({
    required Uint8List bytes,
    required String filename,
    required String mimeType,
  }) async {
    final form = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        bytes,
        filename: filename,
        contentType: MediaType.parse(mimeType),
      ),
    });
    await _dio.post<Map<String, dynamic>>('/settings/qris', data: form);
  }

  Future<void> clearQrisImage() async {
    await _dio.delete<Map<String, dynamic>>('/settings/qris');
  }
}
