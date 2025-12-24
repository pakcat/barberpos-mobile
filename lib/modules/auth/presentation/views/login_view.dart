import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Image with Overlay
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl:
                  'https://images.unsplash.com/photo-1585747860715-2ba37e788b70?q=80&w=2074&auto=format&fit=crop', // Barbershop interior
              fit: BoxFit.cover,
              errorWidget: (context, url, error) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.grey900, Colors.black],
                    ),
                  ),
                );
              },
              placeholder: (context, url) => Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.grey900, Colors.black],
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.6),
                    Colors.black.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
          ),

          // 2. Content with Animation
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimens.spacingLg),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 30 * (1 - value)),
                    child: Opacity(opacity: value, child: child),
                  );
                },
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      AppDimens.cornerRadiusXl,
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(AppDimens.spacingXl),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 1.5,
                          ),
                          borderRadius: BorderRadius.circular(
                            AppDimens.cornerRadiusXl,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Logo
                            Container(
                              padding: const EdgeInsets.all(
                                AppDimens.spacingLg,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.orange500.withValues(
                                  alpha: 0.2,
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.orange500,
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.content_cut_rounded,
                                size: 48,
                                color: AppColors.orange500,
                              ),
                            ),
                            const SizedBox(height: AppDimens.spacingLg),

                            // Title
                            Text(
                              AppStrings.loginTitle,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                            ),
                            const SizedBox(height: AppDimens.spacingXs),
                            const Text(
                              AppStrings.loginSubtitle,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: AppDimens.spacingXl),

                            // Form
                            Form(
                              key: controller.formKey,
                              child: Column(
                                children: [
                                  _buildTextField(
                                    controller: controller.usernameController,
                                    label: AppStrings.usernameLabel,
                                    icon: Icons.person_outline_rounded,
                                    validator: (v) => (v == null || v.isEmpty)
                                        ? AppStrings.requiredField
                                        : null,
                                  ),
                                  const SizedBox(height: AppDimens.spacingMd),
                                  Obx(
                                    () => _buildTextField(
                                      controller: controller.passwordController,
                                      label: AppStrings.passwordLabel,
                                      icon: Icons.lock_outline_rounded,
                                      isPassword: true,
                                      obscureText: controller.obscure.value,
                                      onToggleObscure: controller.toggleObscure,
                                      validator: (v) => (v == null || v.isEmpty)
                                          ? AppStrings.requiredField
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(height: AppDimens.spacingSm),

                                  // Forgot Password
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () =>
                                          Get.toNamed(Routes.forgotPassword),
                                      style: TextButton.styleFrom(
                                        foregroundColor: AppColors.orange500,
                                      ),
                                      child: const Text(
                                        AppStrings.forgotPassword,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: AppDimens.spacingMd),

                                  // Login Button
                                  Obx(
                                    () => SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: controller.loading.value
                                            ? null
                                            : () => controller.submit(),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.orange500,
                                          foregroundColor: Colors.black,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              AppDimens.cornerRadius,
                                            ),
                                          ),
                                        ),
                                        child: controller.loading.value
                                            ? const SizedBox(
                                                width: 24,
                                                height: 24,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2.5,
                                                      color: Colors.black,
                                                    ),
                                              )
                                            : const Text(
                                                AppStrings.loginButton,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: AppDimens.spacingLg),

                                  // Staff Login
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: OutlinedButton(
                                      onPressed: controller.loading.value
                                          ? null
                                          : () => controller.submit(
                                              staffLogin: true,
                                            ),
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          color: Colors.white30,
                                        ),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            AppDimens.cornerRadius,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        AppStrings.staffLoginButton,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: AppDimens.spacingSm),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: OutlinedButton.icon(
                                      onPressed: controller.loading.value
                                          ? null
                                          : controller.loginWithGoogle,
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(
                                          color: Colors.white30,
                                        ),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            AppDimens.cornerRadius,
                                          ),
                                        ),
                                      ),
                                      icon: const Icon(Icons.login_rounded),
                                      label: const Text('Masuk dengan Google'),
                                    ),
                                  ),
                                  const SizedBox(height: AppDimens.spacingMd),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Belum punya akun?',
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Get.offAllNamed(Routes.register),
                                        child: const Text('Daftar'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onToggleObscure,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white60),
        prefixIcon: Icon(icon, color: Colors.white70),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  obscureText
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                  color: Colors.white70,
                ),
                onPressed: onToggleObscure,
              )
            : null,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
          borderSide: const BorderSide(color: AppColors.orange500),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
          borderSide: const BorderSide(color: AppColors.red500),
        ),
      ),
    );
  }
}
