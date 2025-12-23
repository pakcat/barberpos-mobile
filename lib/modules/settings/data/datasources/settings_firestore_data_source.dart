import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/settings_profile.dart';

class SettingsFirestoreDataSource {
  SettingsFirestoreDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  Future<SettingsProfile?> load(String userId) async {
    final doc = await _firestore.collection('settings').doc(userId).get();
    final data = doc.data();
    if (data == null) return null;
    return SettingsProfile(
      businessName: data['businessName']?.toString() ?? '',
      businessAddress: data['businessAddress']?.toString() ?? '',
      businessPhone: data['businessPhone']?.toString() ?? '',
      receiptFooter: data['receiptFooter']?.toString() ?? '',
      defaultPaymentMethod: data['defaultPaymentMethod']?.toString() ?? '',
      printerName: data['printerName']?.toString() ?? '',
      paperSize: data['paperSize']?.toString() ?? '',
      autoPrint: data['autoPrint'] == true,
      notifications: data['notifications'] == true,
      trackStock: data['trackStock'] == true,
      roundingPrice: data['roundingPrice'] == true,
      autoBackup: data['autoBackup'] == true,
      cashierPin: (data['cashierPin']?.toString().isNotEmpty ?? false),
    );
  }

  Future<void> save(String userId, SettingsProfile profile) async {
    await _firestore.collection('settings').doc(userId).set({
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
    }, SetOptions(merge: true));
  }
}
