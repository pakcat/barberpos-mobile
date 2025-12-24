import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/widgets/app_input_field.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../controllers/management_controller.dart';
import '../models/management_models.dart';

class CustomerFormView extends GetView<ManagementController> {
  const CustomerFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final id = Get.arguments as String?;
    final isEdit = id != null;
    final existing = id != null ? controller.getCustomerById(id) : null;

    final nameController = TextEditingController(text: existing?.name ?? '');
    final phoneController = TextEditingController(text: existing?.phone ?? '');
    final emailController = TextEditingController(text: existing?.email ?? '');
    final addressController = TextEditingController(
      text: existing?.address ?? '',
    );

    void save() {
      final name = nameController.text.trim();
      final phone = phoneController.text.trim();
      if (name.isEmpty || phone.isEmpty) return;
      final item = CustomerItem(
        id: id ?? '0',
        name: name,
        phone: phone,
        email: emailController.text.trim(),
        address: addressController.text.trim(),
      );
      controller.upsertCustomer(item);
      Get.back();
    }

    return AppScaffold(
      title: isEdit ? 'Ubah Pelanggan' : 'Tambah Pelanggan',
      onNavigateBack: () async {
        final dirty = nameController.text.isNotEmpty ||
            phoneController.text.isNotEmpty ||
            emailController.text.isNotEmpty ||
            addressController.text.isNotEmpty;
        if (!dirty) return true;
        return await _confirmDiscard();
      },
      backgroundColor: AppColors.grey900,
      appBarBackgroundColor: AppColors.grey900,
      appBarForegroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Get.back(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informasi Pelanggan',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppDimens.spacingLg),
            const Text(
              'Nama Pelanggan *',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: AppDimens.spacingXs),
            AppInputField(
              hint: 'Masukkan nama pelanggan',
              prefix: const Icon(
                Icons.person_rounded,
                color: AppColors.orange500,
              ),
              controller: nameController,
            ),
            const SizedBox(height: AppDimens.spacingMd),
            const Text(
              'Nomor Telepon *',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: AppDimens.spacingXs),
            AppInputField(
              hint: 'Masukkan nomor telepon',
              prefix: const Icon(Icons.phone_rounded, color: AppColors.orange500),
              keyboardType: TextInputType.phone,
              controller: phoneController,
            ),
            const SizedBox(height: AppDimens.spacingMd),
            const Text('Email', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: AppDimens.spacingXs),
            AppInputField(
              hint: 'Masukkan email',
              prefix: const Icon(Icons.mail_rounded, color: AppColors.orange500),
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
            ),
            const SizedBox(height: AppDimens.spacingMd),
            const Text('Alamat', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: AppDimens.spacingXs),
            AppInputField(
              hint: 'Masukkan Alamat',
              controller: addressController,
              maxLines: 3,
            ),
            const SizedBox(height: AppDimens.spacingXl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange500,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimens.spacingMd,
                  ),
                ),
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> _confirmDiscard() async {
  final result = await Get.dialog<bool>(
    AlertDialog(
      backgroundColor: AppColors.grey800,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.cornerRadius)),
      title: const Text('Batalkan perubahan?', style: TextStyle(color: Colors.white)),
      content: const Text(
        'Perubahan belum disimpan. Yakin kembali?',
        style: TextStyle(color: Colors.white70),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(result: false), child: const Text('Lanjutkan')),
        TextButton(onPressed: () => Get.back(result: true), child: const Text('Buang')),
      ],
    ),
  );
  return result ?? false;
}
