import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/values/app_strings.dart';
import '../controllers/complete_profile_controller.dart';

class CompleteProfileView extends GetView<CompleteProfileController> {
  const CompleteProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lengkapi Profil'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimens.spacingXl),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Card(
                color: AppColors.grey800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.cornerRadiusXl),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppDimens.spacingXl),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Lengkapi Profil Anda',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: AppDimens.spacingSm),
                        const Text(
                          'Isi data kontak dan domisili agar akun dapat digunakan penuh.',
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: AppDimens.spacingXl),
                        TextFormField(
                          controller: controller.phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Nomor HP',
                          ),
                          validator: (v) => (v == null || v.isEmpty) ? AppStrings.requiredField : null,
                        ),
                        const SizedBox(height: AppDimens.spacingMd),
                        TextFormField(
                          controller: controller.addressController,
                          decoration: const InputDecoration(
                            labelText: 'Alamat',
                          ),
                          validator: (v) => (v == null || v.isEmpty) ? AppStrings.requiredField : null,
                        ),
                        const SizedBox(height: AppDimens.spacingMd),
                        Obx(
                          () => DropdownButtonFormField<String>(
                            initialValue: controller.selectedRegion.value.isNotEmpty
                                ? controller.selectedRegion.value
                                : (controller.regionOptions.isNotEmpty ? controller.regionOptions.first : null),
                            items: controller.regionOptions
                                .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                                .toList(),
                            decoration: const InputDecoration(labelText: 'Daerah/Kota'),
                            onChanged: (v) {
                              if (v != null) controller.selectedRegion.value = v;
                            },
                            validator: (v) => (v == null || v.isEmpty) ? AppStrings.requiredField : null,
                          ),
                        ),
                        const SizedBox(height: AppDimens.spacingXl),
                        Obx(
                          () => SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: controller.loading.value ? null : controller.submit,
                              child: controller.loading.value
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.black,
                                      ),
                                    )
                                  : const Text('Simpan & Lanjutkan'),
                            ),
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
    );
  }
}
