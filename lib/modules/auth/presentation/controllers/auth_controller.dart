import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/auth_service.dart';
import '../../../../core/services/region_service.dart';
import '../../../../routes/app_routes.dart';

class AuthController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final obscure = true.obs;
  final loading = false.obs;
  final error = RxnString();

  final auth = Get.find<AuthService>();
  final RegionService regionService = Get.find<RegionService>();

  void toggleObscure() => obscure.toggle();

  @override
  void onReady() {
    super.onReady();
    _autoRedirectIfLoggedIn();
  }

  Future<void> submit({bool staffLogin = false}) async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    loading.value = true;
    error.value = null;
    final success = await auth.login(
      usernameController.text.trim().toLowerCase(),
      passwordController.text,
      staffLogin: staffLogin,
    );
    loading.value = false;
    if (!success) {
      final msg = auth.lastError ?? 'Login gagal, periksa kembali data Anda.';
      error.value = msg;
      if (!Get.testMode) {
        Get.snackbar('Login gagal', msg, snackPosition: SnackPosition.BOTTOM);
      }
      return;
    }
    final target = staffLogin ? Routes.closing : Routes.home;
    Get.offAllNamed(target);
  }

  Future<void> loginWithGoogle() async {
    loading.value = true;
    error.value = null;
    final email = usernameController.text.trim().isNotEmpty
        ? usernameController.text.trim().toLowerCase()
        : 'user${DateTime.now().millisecondsSinceEpoch}@google.com';
    final success = await auth.loginWithGoogle(email: email);
    loading.value = false;
    if (!success) {
      final msg = auth.lastError ?? 'Login Google gagal, coba lagi.';
      error.value = msg;
      if (!Get.testMode) {
        Get.snackbar('Login Google', msg, snackPosition: SnackPosition.BOTTOM);
      }
      return;
    }
    final needsProfile = await _needsProfileCompletion();
    if (needsProfile) {
      Get.offAllNamed(Routes.completeProfile);
    } else {
      Get.offAllNamed(Routes.home);
    }
  }

  Future<void> logout({bool confirm = false}) async {
    await auth.logout();
    Get.offAllNamed(Routes.login);
  }
}

extension on AuthController {
  Future<void> _autoRedirectIfLoggedIn() async {
    // Wait for AuthService to finish restoring session from local storage.
    await auth.waitUntilReady();
    if (!auth.isLoggedIn) return;
    final needsProfile = await _needsProfileCompletion();
    if (needsProfile) {
      Get.offAllNamed(Routes.completeProfile);
    } else {
      Get.offAllNamed(Routes.home);
    }
  }

  Future<bool> _needsProfileCompletion() async {
    final user = auth.currentUser;
    if (user == null) return false;
    if (user.phone.isNotEmpty && user.address.isNotEmpty && user.region.isNotEmpty) return false;
    if (regionService.regions.isEmpty) {
      await regionService.load();
    }
    return true;
  }
}
