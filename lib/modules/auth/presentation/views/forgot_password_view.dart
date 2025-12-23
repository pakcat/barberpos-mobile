import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/values/app_strings.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.grey900, Colors.black],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimens.spacingLg),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimens.cornerRadiusXl),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(AppDimens.spacingXl),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                        borderRadius: BorderRadius.circular(AppDimens.cornerRadiusXl),
                      ),
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.forgotPasswordTitle,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: AppDimens.spacingXs),
                            const Text(
                              'Kami akan mengirim tautan reset ke email Anda.',
                              style: TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: AppDimens.spacingLg),
                            TextFormField(
                              controller: controller.emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) =>
                                  v != null && v.contains('@') ? null : 'Masukkan email valid',
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: const TextStyle(color: Colors.white70),
                                prefixIcon: const Icon(Icons.mail_rounded, color: Colors.white70),
                                filled: true,
                                fillColor: Colors.white.withValues(alpha: 0.08),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
                                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
                                  borderSide: const BorderSide(color: AppColors.orange500),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppDimens.spacingMd),
                            Obx(
                              () => controller.error.value != null
                                  ? Text(
                                      controller.error.value!,
                                      style: const TextStyle(color: AppColors.red500),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            Obx(
                              () => controller.info.value != null
                                  ? Text(
                                      controller.info.value!,
                                      style: const TextStyle(color: AppColors.green500),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            const SizedBox(height: AppDimens.spacingMd),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: Obx(
                                () => ElevatedButton(
                                  onPressed:
                                      controller.loading.value ? null : () => controller.submit(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.orange500,
                                    foregroundColor: Colors.black,
                                  ),
                                  child: controller.loading.value
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.black,
                                          ),
                                        )
                                      : const Text('Kirim Tautan Reset'),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppDimens.spacingSm),
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text('Kembali ke login'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
