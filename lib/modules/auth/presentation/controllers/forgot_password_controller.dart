import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/services/auth_service.dart';

class ForgotPasswordController extends GetxController {
  ForgotPasswordController() : auth = Get.find<AuthService>();

  final AuthService auth;

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final RxBool loading = false.obs;
  final RxnString info = RxnString();
  final RxnString error = RxnString();

  Future<void> submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    loading.value = true;
    error.value = null;
    info.value = null;
    final ok = await auth.requestPasswordReset(emailController.text.trim());
    loading.value = false;
    if (!ok) {
      error.value = 'Email tidak ditemukan.';
      return;
    }
    info.value = 'Permintaan reset terkirim. Cek inbox Anda.';
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
