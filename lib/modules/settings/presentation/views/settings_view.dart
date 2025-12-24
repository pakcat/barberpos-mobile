import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_input_field.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_side_drawer.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Pengaturan',
      backgroundColor: AppColors.grey900,
      appBarBackgroundColor: Colors.transparent,
      appBarForegroundColor: Colors.white,
      drawer: const AppSideDrawer(),
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(title: 'Akun Saya', icon: Icons.person_rounded),
            const SizedBox(height: AppDimens.spacingSm),
            AppCard(
              backgroundColor: AppColors.grey800,
              borderColor: AppColors.grey700,
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor: AppColors.orange500,
                      child: Text(
                        controller.user?.name.substring(0, 1).toUpperCase() ?? 'U',
                        style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      controller.user?.name ?? 'Pengguna',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${controller.user?.email ?? '-'} • ${controller.user?.role.name.capitalizeFirst}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                  if (controller.user?.phone.isNotEmpty == true)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          const Icon(Icons.phone_iphone_rounded, size: 16, color: Colors.white54),
                          const SizedBox(width: 8),
                          Text(
                            controller.user!.phone,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  if (controller.user?.address.isNotEmpty == true)
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 16, color: Colors.white54),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              controller.user!.address,
                              style: const TextStyle(color: Colors.white70),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.spacingLg),

            _SectionHeader(title: 'Umum', icon: Icons.tune_rounded),
            const SizedBox(height: AppDimens.spacingSm),
            AppCard(
              backgroundColor: AppColors.grey800,
              borderColor: AppColors.grey700,
              child: Column(
                children: [
                  AppInputField(
                    controller: controller.businessNameController,
                    hint: 'Nama usaha',
                    prefix: const Icon(Icons.storefront_outlined),
                    onChanged: (v) => controller.businessName.value = v,
                  ),
                  const SizedBox(height: AppDimens.spacingSm),
                  AppInputField(
                    controller: controller.businessAddressController,
                    hint: 'Alamat usaha',
                    maxLines: 2,
                    prefix: const Icon(Icons.location_on_outlined),
                    onChanged: (v) => controller.businessAddress.value = v,
                  ),
                  const SizedBox(height: AppDimens.spacingSm),
                  AppInputField(
                    controller: controller.businessPhoneController,
                    hint: 'Nomor telepon',
                    keyboardType: TextInputType.phone,
                    prefix: const Icon(Icons.phone_rounded),
                    onChanged: (v) => controller.businessPhone.value = v,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.spacingLg),

            _SectionHeader(title: 'Printer & Struk', icon: Icons.print_rounded),
            const SizedBox(height: AppDimens.spacingSm),
            AppCard(
              backgroundColor: AppColors.grey800,
              borderColor: AppColors.grey700,
              child: Column(
                children: [
                  AppInputField(
                    controller: controller.printerNameController,
                    hint: 'Nama printer (opsional)',
                    prefix: const Icon(Icons.print_rounded),
                    onChanged: (v) => controller.printerName.value = v,
                  ),
                  const SizedBox(height: AppDimens.spacingSm),
                  Obx(
                    () => DropdownButtonFormField<String>(
                      initialValue: const {'58mm', '80mm', 'A4'}.contains(controller.paperSize.value)
                          ? controller.paperSize.value
                          : null,
                      dropdownColor: AppColors.grey800,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Ukuran Kertas',
                        labelStyle: const TextStyle(color: Colors.white54),
                        prefixIcon: const Icon(Icons.receipt_rounded, color: Colors.white54),
                        filled: true,
                        fillColor: AppColors.grey800,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
                          borderSide: const BorderSide(color: AppColors.grey700),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
                          borderSide: const BorderSide(color: AppColors.grey700),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
                          borderSide: const BorderSide(color: AppColors.orange500),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: '58mm', child: Text('58mm (Thermal Kecil)')),
                        DropdownMenuItem(value: '80mm', child: Text('80mm (Thermal Besar)')),
                        DropdownMenuItem(value: 'A4', child: Text('A4 (Standar)')),
                      ],
                      onChanged: controller.setPaperSize,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spacingSm),
                  AppInputField(
                    controller: controller.receiptFooterController,
                    hint: 'Catatan struk (footer)',
                    maxLines: 2,
                    prefix: const Icon(Icons.notes_rounded),
                    onChanged: (v) => controller.receiptFooter.value = v,
                  ),
                  const SizedBox(height: AppDimens.spacingSm),
                  Obx(
                    () => _SwitchTile(
                      label: 'Cetak struk otomatis',
                      value: controller.autoPrint.value,
                      onChanged: (v) => controller.autoPrint.value = v,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.spacingLg),

            _SectionHeader(title: 'Preferensi', icon: Icons.settings_suggest_rounded),
            const SizedBox(height: AppDimens.spacingSm),
            AppCard(
              backgroundColor: AppColors.grey800,
              borderColor: AppColors.grey700,
              child: Column(
                children: [
                  Obx(
                    () => _SwitchTile(
                      label: 'Notifikasi',
                      value: controller.notifications.value,
                      onChanged: (v) => controller.notifications.value = v,
                    ),
                  ),
                  const Divider(color: Colors.white10, height: 1),
                  Obx(
                    () => _SwitchTile(
                      label: 'Lacak stok produk',
                      value: controller.trackStock.value,
                      onChanged: (v) => controller.trackStock.value = v,
                    ),
                  ),
                  const Divider(color: Colors.white10, height: 1),
                  Obx(
                    () => _SwitchTile(
                      label: 'Bulatkan harga (ke ratusan)',
                      value: controller.roundingPrice.value,
                      onChanged: (v) => controller.roundingPrice.value = v,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.spacingLg),

            _SectionHeader(title: 'Keamanan', icon: Icons.security_rounded),
            const SizedBox(height: AppDimens.spacingSm),
            AppCard(
              backgroundColor: AppColors.grey800,
              borderColor: AppColors.grey700,
              child: Column(
                children: [
                  Obx(
                    () => _SwitchTile(
                      label: 'PIN kasir untuk transaksi',
                      value: controller.cashierPin.value,
                      onChanged: (v) => controller.cashierPin.value = v,
                    ),
                  ),
                  const Divider(color: Colors.white10, height: 1),
                  Obx(
                    () => _SwitchTile(
                      label: 'Backup otomatis ke cloud',
                      value: controller.autoBackup.value,
                      onChanged: (v) => controller.autoBackup.value = v,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.spacingLg),
            _SectionHeader(title: 'Reset Password', icon: Icons.lock_reset_rounded),
            const SizedBox(height: AppDimens.spacingSm),
            AppCard(
              backgroundColor: AppColors.grey800,
              borderColor: AppColors.grey700,
              child: Column(
                children: [
                  TextField(
                    controller: controller.currentPasswordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Password sekarang',
                      prefixIcon: Icon(Icons.lock_outline_rounded),
                    ),
                  ),
                  const SizedBox(height: AppDimens.spacingSm),
                  TextField(
                    controller: controller.newPasswordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Password baru',
                      prefixIcon: Icon(Icons.lock_reset_rounded),
                    ),
                  ),
                  const SizedBox(height: AppDimens.spacingSm),
                  TextField(
                    controller: controller.confirmPasswordController,
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Konfirmasi password baru',
                      prefixIcon: Icon(Icons.verified_user_rounded),
                    ),
                  ),
                  const SizedBox(height: AppDimens.spacingSm),
                  Obx(
                    () => controller.passwordError.value != null
                        ? Text(
                            controller.passwordError.value!,
                            style: const TextStyle(color: AppColors.red500),
                          )
                        : const SizedBox.shrink(),
                  ),
                  Obx(
                    () => controller.passwordInfo.value != null
                        ? Text(
                            controller.passwordInfo.value!,
                            style: const TextStyle(color: AppColors.green500),
                          )
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(height: AppDimens.spacingSm),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: controller.resetPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.orange500,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: AppDimens.spacingMd),
                      ),
                      icon: const Icon(Icons.save_alt_rounded),
                      label: const Text('Perbarui Password'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.spacingLg),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: controller.saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange500,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: AppDimens.spacingMd),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
                  ),
                ),
                icon: const Icon(Icons.save_rounded),
                label: const Text(
                  'Simpan Perubahan',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: AppDimens.spacingXl),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.orange500, size: 20),
        const SizedBox(width: AppDimens.spacingSm),
        Text(
          title,
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({required this.label, required this.value, required this.onChanged});

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white)),
          Switch(
            value: value,
            activeTrackColor: AppColors.orange500,
            activeThumbColor: Colors.black,
            inactiveTrackColor: Colors.black26,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
