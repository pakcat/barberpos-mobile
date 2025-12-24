import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/services/region_service.dart';
import '../../../../routes/app_routes.dart';

class RegisterController extends GetxController {
  RegisterController()
    : auth = Get.find<AuthService>(),
      regionsService = Get.find<RegionService>();

  final AuthService auth;
  final RegionService regionsService;

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final RxString region = ''.obs;
  final RxBool loading = false.obs;
  final RxnString error = RxnString();

  List<String> get regions => regionsService.regions;

  @override
  void onInit() {
    super.onInit();
    _initRegion();
    _loadRegionsIfNeeded();
  }

  void _initRegion() {
    if (regionsService.regions.isNotEmpty) {
      region.value = regionsService.regions.first;
    }
    ever<List<String>>(regionsService.regions, (list) {
      if (region.value.isEmpty && list.isNotEmpty) {
        region.value = list.first;
      }
    });
  }

  Future<void> _loadRegionsIfNeeded() async {
    if (regionsService.regions.isEmpty) {
      await regionsService.load();
      if (regionsService.regions.isNotEmpty && region.value.isEmpty) {
        region.value = regionsService.regions.first;
      }
    }
  }

  Future<void> registerWithEmail() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    loading.value = true;
    error.value = null;
    final success = await auth.registerWithEmail(
      name: nameController.text.trim(),
      email: emailController.text.trim().toLowerCase(),
      password: passwordController.text,
      phone: phoneController.text.trim(),
      address: addressController.text.trim(),
      region: region.value,
    );
    loading.value = false;
    if (!success) {
      final msg =
          auth.lastError ?? 'Email sudah terdaftar, coba gunakan email lain.';
      error.value = msg;
      if (!Get.testMode) {
        Get.snackbar(
          'Registrasi gagal',
          msg,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      return;
    }
    Get.offAllNamed(Routes.home);
  }

  Future<void> registerWithGoogle() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    loading.value = true;
    error.value = null;
    final success = await auth.registerWithGoogle(
      email: emailController.text.trim().isNotEmpty
          ? emailController.text.trim().toLowerCase()
          : 'user${DateTime.now().millisecondsSinceEpoch}@google.com',
      name: nameController.text.trim().isNotEmpty
          ? nameController.text.trim()
          : null,
      phone: phoneController.text.trim(),
      address: addressController.text.trim(),
      region: region.value,
    );
    loading.value = false;
    if (!success) {
      error.value = 'Registrasi Google gagal, email sudah dipakai?';
      return;
    }
    Get.offAllNamed(Routes.home);
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }
}
