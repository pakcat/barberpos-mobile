import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:get/get.dart';

import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../controllers/bluetooth_printer_controller.dart';

class BluetoothPrinterView extends GetView<BluetoothPrinterController> {
  const BluetoothPrinterView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Printer Bluetooth',
      backgroundColor: AppColors.grey900,
      appBarBackgroundColor: Colors.transparent,
      appBarForegroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Get.back(),
      ),
      actions: [
        Obx(
          () => IconButton(
            tooltip: 'Refresh',
            onPressed: controller.loading.value ? null : controller.loadDevices,
            icon: controller.loading.value
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh_rounded),
          ),
        ),
      ],
      body: Obx(() {
        final enabled = controller.enabled.value;
        final selected = controller.selectedMac;
        final devices = controller.bondedDevices;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppCard(
                backgroundColor: AppColors.grey800,
                borderColor: AppColors.grey700,
                padding: const EdgeInsets.all(AppDimens.spacingLg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status Bluetooth',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: AppDimens.spacingSm),
                    Row(
                      children: [
                        Icon(
                          enabled ? Icons.bluetooth_connected_rounded : Icons.bluetooth_disabled_rounded,
                          color: enabled ? AppColors.green500 : AppColors.red500,
                        ),
                        const SizedBox(width: AppDimens.spacingSm),
                        Text(
                          enabled ? 'Bluetooth aktif' : 'Bluetooth tidak aktif',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimens.spacingMd),
                    Wrap(
                      spacing: AppDimens.spacingSm,
                      runSpacing: AppDimens.spacingSm,
                      children: [
                        ElevatedButton.icon(
                          onPressed: enabled || controller.enabling.value ? null : controller.requestEnable,
                          icon: controller.enabling.value
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.power_settings_new_rounded),
                          label: const Text('Aktifkan Bluetooth'),
                        ),
                        OutlinedButton.icon(
                          onPressed: controller.openBluetoothSettings,
                          icon: const Icon(Icons.settings_rounded),
                          label: const Text('Buka pengaturan'),
                          style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.grey700)),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppDimens.spacingMd),
                    Text(
                      selected.isEmpty ? 'Printer terpilih: -' : 'Printer terpilih: $selected',
                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimens.spacingLg),
              const Text(
                'Perangkat paired',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppDimens.spacingSm),
              if (!enabled)
                const AppCard(
                  backgroundColor: AppColors.grey800,
                  borderColor: AppColors.grey700,
                  padding: EdgeInsets.all(AppDimens.spacingLg),
                  child: Text(
                    'Aktifkan Bluetooth dulu untuk melihat daftar perangkat paired.',
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              else if (devices.isEmpty)
                const AppCard(
                  backgroundColor: AppColors.grey800,
                  borderColor: AppColors.grey700,
                  padding: EdgeInsets.all(AppDimens.spacingLg),
                  child: Text(
                    'Belum ada perangkat paired. Pair printer kamu lewat pengaturan Bluetooth, lalu refresh.',
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              else
                ...devices.map((d) => _DeviceTile(device: d, selectedMac: selected)),
            ],
          ),
        );
      }),
    );
  }
}

class _DeviceTile extends StatelessWidget {
  const _DeviceTile({required this.device, required this.selectedMac});

  final BluetoothDevice device;
  final String selectedMac;

  @override
  Widget build(BuildContext context) {
    final isSelected = device.address == selectedMac;
    final title = (device.name ?? '').trim().isEmpty ? 'Perangkat Bluetooth' : device.name!.trim();

    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.spacingSm),
      child: AppCard(
        backgroundColor: AppColors.grey800,
        borderColor: isSelected ? AppColors.orange500 : AppColors.grey700,
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingMd, vertical: AppDimens.spacingSm),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(
            isSelected ? Icons.check_circle_rounded : Icons.bluetooth_rounded,
            color: isSelected ? AppColors.orange500 : Colors.white70,
          ),
          title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          subtitle: Text(device.address, style: const TextStyle(color: Colors.white54)),
          trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white54),
          onTap: () => Get.find<BluetoothPrinterController>().selectDevice(device),
        ),
      ),
    );
  }
}
