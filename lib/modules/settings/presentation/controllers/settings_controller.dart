import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/auth_service.dart';
import '../../domain/entities/settings_profile.dart';
import '../../domain/usecases/get_settings.dart';
import '../../domain/usecases/save_settings.dart';

class SettingsController extends GetxController {
  SettingsController({
    required GetSettingsUseCase getSettings,
    required SaveSettingsUseCase saveSettings,
  }) : _getSettings = getSettings,
       _saveSettings = saveSettings;

  final GetSettingsUseCase _getSettings;
  final SaveSettingsUseCase _saveSettings;
  final AuthService _auth = Get.find<AuthService>();

  AppUser? get user => _auth.currentUser;

  final RxString businessName = ''.obs;
  final RxString businessAddress = ''.obs;
  final RxString businessPhone = ''.obs;
  final RxString receiptFooter = ''.obs;
  final RxString defaultPaymentMethod = ''.obs;
  final RxString printerName = ''.obs;
  final RxString printerType = 'system'.obs;
  final RxString printerHost = ''.obs;
  final RxInt printerPort = 9100.obs;
  final RxString printerMac = ''.obs;
  final RxString paperSize = SettingsProfile.defaults().paperSize.obs;

  final RxBool autoPrint = true.obs;
  final RxBool notifications = true.obs;
  final RxBool trackStock = true.obs;
  final RxBool roundingPrice = false.obs;
  final RxBool autoBackup = true.obs;
  final RxBool cashierPin = false.obs;

  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController businessAddressController =
      TextEditingController();
  final TextEditingController businessPhoneController = TextEditingController();
  final TextEditingController receiptFooterController = TextEditingController();
  final TextEditingController printerNameController = TextEditingController();
  final TextEditingController printerHostController = TextEditingController();
  final TextEditingController printerPortController = TextEditingController();
  final TextEditingController printerMacController = TextEditingController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final RxBool loading = false.obs;
  final RxnString passwordError = RxnString();
  final RxnString passwordInfo = RxnString();

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    loading.value = true;
    final profile = await _getSettings();
    _applyProfile(profile);
    loading.value = false;
  }

  void _applyProfile(SettingsProfile profile) {
    businessName.value = profile.businessName;
    businessAddress.value = profile.businessAddress;
    businessPhone.value = profile.businessPhone;
    receiptFooter.value = profile.receiptFooter;
    defaultPaymentMethod.value = profile.defaultPaymentMethod;
    printerName.value = profile.printerName;
    printerType.value = profile.printerType;
    printerHost.value = profile.printerHost;
    printerPort.value = profile.printerPort;
    printerMac.value = profile.printerMac;
    const supportedPaperSizes = {'58mm', '80mm', 'A4'};
    final normalizedPaperSize = supportedPaperSizes.contains(profile.paperSize)
        ? profile.paperSize
        : SettingsProfile.defaults().paperSize;
    paperSize.value = normalizedPaperSize;
    autoPrint.value = profile.autoPrint;
    notifications.value = profile.notifications;
    trackStock.value = profile.trackStock;
    roundingPrice.value = profile.roundingPrice;
    autoBackup.value = profile.autoBackup;
    cashierPin.value = profile.cashierPin;

    businessNameController.text = businessName.value;
    businessAddressController.text = businessAddress.value;
    businessPhoneController.text = businessPhone.value;
    receiptFooterController.text = receiptFooter.value;
    printerNameController.text = printerName.value;
    printerHostController.text = printerHost.value;
    printerPortController.text = printerPort.value.toString();
    printerMacController.text = printerMac.value;
  }

  void setDefaultPayment(String value) {
    defaultPaymentMethod.value = value;
  }

  void setPaperSize(String? value) {
    if (value != null) paperSize.value = value;
  }

  void setPrinterType(String? value) {
    if (value == null) return;
    final normalized = value.trim().toLowerCase();
    if (normalized == 'system' || normalized == 'lan' || normalized == 'bluetooth') {
      printerType.value = normalized;
    }
  }

  Future<void> saveProfile() async {
    const supportedPaperSizes = {'58mm', '80mm', 'A4'};
    final normalizedPaperSize = supportedPaperSizes.contains(paperSize.value)
        ? paperSize.value
        : SettingsProfile.defaults().paperSize;
    final profile = SettingsProfile(
      businessName: businessNameController.text.trim(),
      businessAddress: businessAddressController.text.trim(),
      businessPhone: businessPhoneController.text.trim(),
      receiptFooter: receiptFooterController.text.trim(),
      defaultPaymentMethod: defaultPaymentMethod.value,
      printerName: printerNameController.text.trim(),
      printerType: printerType.value,
      printerHost: printerHostController.text.trim(),
      printerPort: int.tryParse(printerPortController.text.trim()) ?? 9100,
      printerMac: printerMacController.text.trim(),
      paperSize: normalizedPaperSize,
      autoPrint: autoPrint.value,
      notifications: notifications.value,
      trackStock: trackStock.value,
      roundingPrice: roundingPrice.value,
      autoBackup: autoBackup.value,
      cashierPin: cashierPin.value,
    );
    await _saveSettings(profile);
    _applyProfile(profile);
    Get.snackbar(
      'Pengaturan disimpan',
      'Profil usaha dan preferensi diperbarui',
    );
  }

  @override
  void onClose() {
    businessNameController.dispose();
    businessAddressController.dispose();
    businessPhoneController.dispose();
    receiptFooterController.dispose();
    printerNameController.dispose();
    printerHostController.dispose();
    printerPortController.dispose();
    printerMacController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  Future<void> resetPassword() async {
    passwordError.value = null;
    passwordInfo.value = null;
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;
    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      passwordError.value = 'Password baru wajib diisi';
      return;
    }
    if (newPassword != confirmPassword) {
      passwordError.value = 'Konfirmasi password tidak sama';
      return;
    }
    final ok = await _auth.changePasswordForCurrent(
      newPassword: newPassword,
      currentPassword: currentPasswordController.text.isEmpty
          ? null
          : currentPasswordController.text,
    );
    if (!ok) {
      passwordError.value =
          _auth.lastError ?? 'Password lama salah atau pengguna belum login.';
      return;
    }
    passwordInfo.value = 'Password diperbarui';
    currentPasswordController.clear();
    newPasswordController.clear();
    confirmPasswordController.clear();
  }
}
