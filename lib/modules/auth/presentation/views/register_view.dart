import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1585747860715-2ba37e788b70?q=80&w=2074&auto=format&fit=crop',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.black.withValues(alpha: 0.9),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppDimens.spacingLg),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimens.cornerRadiusXl),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: const EdgeInsets.all(AppDimens.spacingXl),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.12), width: 1.2),
                        borderRadius: BorderRadius.circular(AppDimens.cornerRadiusXl),
                      ),
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.registerTitle,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: AppDimens.spacingXs),
                            const Text(
                              'Buat akun baru untuk mulai menggunakan backoffice.',
                              style: TextStyle(color: Colors.white70),
                            ),
                            const SizedBox(height: AppDimens.spacingLg),
                            _field(
                              controller: controller.nameController,
                              label: 'Nama Lengkap',
                              icon: Icons.badge_rounded,
                              validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                            ),
                            const SizedBox(height: AppDimens.spacingMd),
                            _field(
                              controller: controller.emailController,
                              label: 'Email',
                              icon: Icons.mail_outline_rounded,
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) =>
                                  v != null && v.contains('@') ? null : 'Masukkan email valid',
                            ),
                            const SizedBox(height: AppDimens.spacingMd),
                            _field(
                              controller: controller.phoneController,
                              label: 'Nomor HP',
                              icon: Icons.phone_rounded,
                              keyboardType: TextInputType.phone,
                              validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                            ),
                            const SizedBox(height: AppDimens.spacingMd),
                            _regionDropdown(controller),
                            const SizedBox(height: AppDimens.spacingMd),
                            _field(
                              controller: controller.addressController,
                              label: 'Alamat Lengkap',
                              icon: Icons.home_work_outlined,
                              maxLines: 2,
                              validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                            ),
                            const SizedBox(height: AppDimens.spacingMd),
                            _field(
                              controller: controller.passwordController,
                              label: 'Password',
                              icon: Icons.lock_outline_rounded,
                              obscureText: true,
                              validator: (v) =>
                                  v != null && v.length >= 6 ? null : 'Minimal 6 karakter',
                            ),
                            const SizedBox(height: AppDimens.spacingMd),
                            Obx(
                              () => controller.error.value != null
                                  ? Padding(
                                      padding: const EdgeInsets.only(bottom: AppDimens.spacingSm),
                                      child: Text(
                                        controller.error.value!,
                                        style: const TextStyle(color: AppColors.red500),
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                            ),
                            Obx(
                              () => SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: controller.loading.value
                                      ? null
                                      : () => controller.registerWithEmail(),
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
                                      : const Text(
                                          'Daftar dengan Email',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppDimens.spacingSm),
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: OutlinedButton.icon(
                                onPressed: controller.loading.value
                                    ? null
                                    : () => controller.registerWithGoogle(),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.white30),
                                  foregroundColor: Colors.white,
                                ),
                                icon: const Icon(Icons.login_rounded),
                                label: const Text('Daftar dengan Google'),
                              ),
                            ),
                            const SizedBox(height: AppDimens.spacingMd),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Sudah punya akun?',
                                  style: TextStyle(color: Colors.white70)),
                              TextButton(
                                onPressed: () => Get.offAllNamed(Routes.login),
                                child: const Text('Masuk'),
                              ),
                            ],
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

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
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
    );
  }

  Widget _regionDropdown(RegisterController controller) {
    return Obx(
      () => DropdownButtonFormField<String>(
        key: ValueKey(controller.region.value),
        initialValue: controller.region.value.isEmpty ? null : controller.region.value,
        dropdownColor: AppColors.grey800,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: 'Kota/Daerah',
          labelStyle: const TextStyle(color: Colors.white70),
          prefixIcon: const Icon(Icons.location_on_outlined, color: Colors.white70),
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
        items: controller.regions
            .map((r) => DropdownMenuItem(value: r, child: Text(r)))
            .toList(),
        onChanged: (value) {
          if (value != null) controller.region.value = value;
        },
        validator: (v) => v == null || v.isEmpty ? 'Pilih daerah' : null,
      ),
    );
  }
}
