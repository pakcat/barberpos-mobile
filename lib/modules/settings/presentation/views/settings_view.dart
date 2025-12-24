import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/printing/thermal_printer_service.dart';
import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_input_field.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_side_drawer.dart';
import '../../../../routes/app_routes.dart';
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
                        controller.user?.name.substring(0, 1).toUpperCase() ??
                            'U',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      controller.user?.name ?? 'Pengguna',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
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
                          const Icon(
                            Icons.phone_iphone_rounded,
                            size: 16,
                            color: Colors.white54,
                          ),
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
                          const Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Colors.white54,
                          ),
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
                      key: ValueKey<String>(
                        'paperSize:${controller.paperSize.value}',
                      ),
                      initialValue:
                          const {
                            '58mm',
                            '80mm',
                            'A4',
                          }.contains(controller.paperSize.value)
                          ? controller.paperSize.value
                          : '58mm',
                      dropdownColor: AppColors.grey800,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Ukuran Kertas',
                        labelStyle: const TextStyle(color: Colors.white54),
                        prefixIcon: const Icon(
                          Icons.receipt_rounded,
                          color: Colors.white54,
                        ),
                        filled: true,
                        fillColor: AppColors.grey800,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimens.cornerRadius,
                          ),
                          borderSide: const BorderSide(
                            color: AppColors.grey700,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimens.cornerRadius,
                          ),
                          borderSide: const BorderSide(
                            color: AppColors.grey700,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimens.cornerRadius,
                          ),
                          borderSide: const BorderSide(
                            color: AppColors.orange500,
                          ),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: '58mm',
                          child: Text('58mm (Thermal Kecil)'),
                        ),
                        DropdownMenuItem(
                          value: '80mm',
                          child: Text('80mm (Thermal Besar)'),
                        ),
                        DropdownMenuItem(
                          value: 'A4',
                          child: Text('A4 (Standar)'),
                        ),
                      ],
                      onChanged: controller.setPaperSize,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spacingSm),
                  Obx(
                    () => DropdownButtonFormField<String>(
                      key: ValueKey<String>(
                        'printerType:${controller.printerType.value}',
                      ),
                      initialValue:
                          const {
                            'system',
                            'lan',
                            'bluetooth',
                          }.contains(controller.printerType.value)
                          ? controller.printerType.value
                          : 'system',
                      dropdownColor: AppColors.grey800,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Tipe Printer',
                        labelStyle: const TextStyle(color: Colors.white54),
                        prefixIcon: const Icon(
                          Icons.print_rounded,
                          color: Colors.white54,
                        ),
                        filled: true,
                        fillColor: AppColors.grey800,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimens.cornerRadius,
                          ),
                          borderSide: const BorderSide(
                            color: AppColors.grey700,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimens.cornerRadius,
                          ),
                          borderSide: const BorderSide(
                            color: AppColors.grey700,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimens.cornerRadius,
                          ),
                          borderSide: const BorderSide(
                            color: AppColors.orange500,
                          ),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'system',
                          child: Text('System Print (Dialog OS)'),
                        ),
                        DropdownMenuItem(
                          value: 'lan',
                          child: Text('Thermal LAN (TCP)'),
                        ),
                        DropdownMenuItem(
                          value: 'bluetooth',
                          child: Text('Thermal Bluetooth (SPP)'),
                        ),
                      ],
                      onChanged: controller.setPrinterType,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spacingSm),
                  Obx(() {
                    if (controller.printerType.value == 'lan') {
                      return Column(
                        children: [
                          AppInputField(
                            controller: controller.printerHostController,
                            hint: 'IP Printer (contoh: 192.168.1.50)',
                            prefix: const Icon(Icons.wifi_rounded),
                            onChanged: (v) => controller.printerHost.value = v,
                          ),
                          const SizedBox(height: AppDimens.spacingSm),
                          AppInputField(
                            controller: controller.printerPortController,
                            hint: 'Port (default 9100)',
                            keyboardType: TextInputType.number,
                            prefix: const Icon(Icons.settings_ethernet_rounded),
                            onChanged: (v) => controller.printerPort.value =
                                int.tryParse(v.trim()) ?? 9100,
                          ),
                        ],
                      );
                    }
                    if (controller.printerType.value == 'bluetooth') {
                      return Column(
                        children: [
                          AppInputField(
                            controller: controller.printerMacController,
                            hint: 'MAC Printer (contoh: 00:11:22:33:44:55)',
                            prefix: const Icon(Icons.bluetooth_rounded),
                            onChanged: (v) => controller.printerMac.value = v,
                          ),
                          const SizedBox(height: AppDimens.spacingSm),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: () => Get.toNamed(Routes.bluetoothPrinter),
                              icon: const Icon(Icons.settings_bluetooth_rounded, color: Colors.white70),
                              label: const Text(
                                'Buka pengaturan Bluetooth printer',
                                style: TextStyle(color: Colors.white70),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                  const SizedBox(height: AppDimens.spacingSm),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        try {
                          await ThermalPrinterService().testPrint();
                          Get.snackbar('Printer', 'Test print dikirim');
                        } catch (e) {
                          Get.snackbar('Gagal print', e.toString());
                        }
                      },
                      icon: const Icon(
                        Icons.receipt_long_rounded,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Test print thermal',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.grey700),
                      ),
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

            _SectionHeader(
              title: 'Preferensi',
              icon: Icons.settings_suggest_rounded,
            ),
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

            _SectionHeader(
              title: 'Pembayaran QRIS',
              icon: Icons.qr_code_rounded,
            ),
            const SizedBox(height: AppDimens.spacingSm),
            AppCard(
              backgroundColor: AppColors.grey800,
              borderColor: AppColors.grey700,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Upload foto QRIS statis (sementara belum terhubung Midtrans/Xendit).',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: AppDimens.spacingSm),
                  Obx(() {
                    if (controller.qrisLoading.value) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppDimens.spacingMd),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    final bytes = controller.qrisImage.value;
                    if (bytes == null) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppDimens.spacingMd),
                        decoration: BoxDecoration(
                          color: AppColors.grey900,
                          borderRadius: BorderRadius.circular(
                            AppDimens.cornerRadius,
                          ),
                          border: Border.all(color: AppColors.grey700),
                        ),
                        child: const Text(
                          'Belum ada foto QRIS. Upload untuk menampilkan di kasir.',
                          style: TextStyle(color: Colors.white60),
                        ),
                      );
                    }
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.all(AppDimens.spacingSm),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                            AppDimens.cornerRadius,
                          ),
                        ),
                        child: Image.memory(
                          bytes,
                          width: 240,
                          height: 240,
                          fit: BoxFit.contain,
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: AppDimens.spacingSm),
                  Obx(
                    () => Wrap(
                      spacing: AppDimens.spacingSm,
                      runSpacing: AppDimens.spacingSm,
                      children: [
                        ElevatedButton.icon(
                          onPressed: controller.qrisUploading.value
                              ? null
                              : controller.pickAndUploadQrisFromGallery,
                          icon: controller.qrisUploading.value
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.photo_library_rounded),
                          label: const Text('Upload dari galeri'),
                        ),
                        if (controller.qrisImage.value != null)
                          OutlinedButton.icon(
                            onPressed: controller.qrisUploading.value
                                ? null
                                : controller.clearQris,
                            icon: const Icon(Icons.delete_outline_rounded),
                            label: const Text('Hapus'),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.grey700),
                            ),
                          ),
                      ],
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
            _SectionHeader(
              title: 'Reset Password',
              icon: Icons.lock_reset_rounded,
            ),
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
                        padding: const EdgeInsets.symmetric(
                          vertical: AppDimens.spacingMd,
                        ),
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
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimens.spacingMd,
                  ),
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
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _SwitchTile extends StatelessWidget {
  const _SwitchTile({
    required this.label,
    required this.value,
    required this.onChanged,
  });

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
