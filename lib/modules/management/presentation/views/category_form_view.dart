import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/widgets/app_input_field.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../controllers/management_controller.dart';
import '../models/management_models.dart';

class CategoryFormView extends GetView<ManagementController> {
  const CategoryFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final id = Get.arguments as String?;
    final isEdit = id != null;
    final existing = id != null ? controller.getCategoryById(id) : null;
    final nameController = TextEditingController(
      text: existing != null ? existing.name : '',
    );

    void save() {
      final name = nameController.text.trim();
      if (name.isEmpty) return;
      final item = CategoryItem(
        id: id ?? DateTime.now().toIso8601String(),
        name: name,
      );
      controller.upsertCategory(item);
      Get.back();
    }

    void delete() {
      if (id == null) return;
      controller.deleteCategory(id);
      Get.back();
    }

    return AppScaffold(
      title: isEdit ? 'Ubah Kategori' : 'Buat Kategori',
      onNavigateBack: () async {
        if (nameController.text.trim().isEmpty) return true;
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
              'Detail Kategori',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppDimens.spacingLg),
            const Text(
              'Nama Kategori *',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: AppDimens.spacingXs),
            AppInputField(
              hint: 'Masukkan nama kategori',
              controller: nameController,
            ),
            const SizedBox(height: AppDimens.spacingXl),
            Row(
              children: [
                if (isEdit)
                  Expanded(
                    child: TextButton(
                      onPressed: delete,
                      child: const Text(
                        'Hapus',
                        style: TextStyle(color: AppColors.red500),
                      ),
                    ),
                  ),
                if (isEdit) const SizedBox(width: AppDimens.spacingSm),
                Expanded(
                  flex: 2,
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
