import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../controllers/staff_controller.dart';
import '../models/employee_model.dart';

class EmployeeFormView extends GetView<StaffController> {
  const EmployeeFormView({super.key});

  @override
  Widget build(BuildContext context) {
    final id = Get.arguments as String?;
    final existing = id != null ? controller.getById(id) : null;
    final name = TextEditingController(text: existing?.name ?? '');
    final roles = ['Admin', 'Manager', 'Kasir', 'Barber'];
    String selectedRole = existing?.role ?? roles.first;
    final phone = TextEditingController(text: existing?.phone ?? '');
    final email = TextEditingController(text: existing?.email ?? '');
    final pin = TextEditingController(text: existing?.pin ?? '');
    final commission = TextEditingController(
      text: existing?.commission?.toString() ?? '',
    );
    var status = existing?.status ?? EmployeeStatus.active;

    void save() {
      if (name.text.trim().isEmpty) {
        Get.snackbar('Validasi', 'Nama wajib diisi');
        return;
      }
      controller.upsert(
        Employee(
          id: id ?? DateTime.now().toIso8601String(),
          name: name.text.trim(),
          role: selectedRole,
          phone: phone.text.trim(),
          email: email.text.trim(),
          pin: pin.text.trim().isEmpty ? existing?.pin : pin.text.trim(),
          joinDate: existing?.joinDate ?? DateTime.now(),
          commission: double.tryParse(commission.text.trim()),
          status: status,
        ),
      );
    }

    return AppScaffold(
      title: existing != null ? 'Ubah Karyawan' : 'Tambah Karyawan',
      backgroundColor: AppColors.grey900,
      appBarBackgroundColor: Colors.transparent,
      appBarForegroundColor: Colors.white,
      onNavigateBack: () async {
        final dirty =
            name.text.trim().isNotEmpty ||
            phone.text.trim().isNotEmpty ||
            email.text.trim().isNotEmpty ||
            pin.text.trim().isNotEmpty ||
            commission.text.trim().isNotEmpty ||
            selectedRole != (existing?.role ?? roles.first);
        if (!dirty) return true;
        return await _confirmDiscard();
      },
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: 'Nama Lengkap *'),
            ),
            const SizedBox(height: AppDimens.spacingMd),
            DropdownButtonFormField<String>(
              initialValue: selectedRole,
              decoration: const InputDecoration(labelText: 'Role *'),
              dropdownColor: AppColors.grey800,
              items: roles
                  .map(
                    (r) => DropdownMenuItem<String>(value: r, child: Text(r)),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) selectedRole = value;
              },
            ),
            const SizedBox(height: AppDimens.spacingMd),
            TextField(
              controller: phone,
              decoration: const InputDecoration(labelText: 'No HP'),
            ),
            const SizedBox(height: AppDimens.spacingMd),
            TextField(
              controller: email,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: AppDimens.spacingMd),
            TextField(
              controller: pin,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'PIN (Opsional)',
                helperText: 'Kosongkan jika tidak ingin mengubah PIN',
              ),
            ),
            const SizedBox(height: AppDimens.spacingMd),
            TextField(
              controller: commission,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Komisi (%)'),
            ),
            const SizedBox(height: AppDimens.spacingMd),
            DropdownButtonFormField<EmployeeStatus>(
              initialValue: status,
              decoration: const InputDecoration(labelText: 'Status'),
              dropdownColor: AppColors.grey800,
              items: const [
                DropdownMenuItem(
                  value: EmployeeStatus.active,
                  child: Text('Aktif'),
                ),
                DropdownMenuItem(
                  value: EmployeeStatus.inactive,
                  child: Text('Nonaktif'),
                ),
              ],
              onChanged: (v) {
                if (v != null) status = v;
              },
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
      ),
      title: const Text(
        'Batalkan perubahan?',
        style: TextStyle(color: Colors.white),
      ),
      content: const Text(
        'Perubahan belum disimpan. Yakin kembali?',
        style: TextStyle(color: Colors.white70),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: const Text('Lanjutkan'),
        ),
        TextButton(
          onPressed: () => Get.back(result: true),
          child: const Text('Buang'),
        ),
      ],
    ),
  );
  return result ?? false;
}
