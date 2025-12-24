import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/utils/local_time.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_side_drawer.dart';
import '../controllers/closing_controller.dart';

class ClosingView extends GetView<ClosingController> {
  const ClosingView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Tutup Buku',
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
            const AppSectionHeader(
              title: 'Ringkasan Shift',
              subtitle: 'Periksa transaksi sebelum menutup buku',
            ),
            const SizedBox(height: AppDimens.spacingMd),
            Obx(
              () => Container(
                padding: const EdgeInsets.all(AppDimens.spacingLg),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.grey800, Colors.black87],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
                  border: Border.all(color: AppColors.grey700),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _SummaryItem(
                        label: 'Cash',
                        value: 'Rp${controller.totalCash.value}',
                        icon: Icons.payments_rounded,
                        color: AppColors.green500,
                      ),
                    ),
                    Container(width: 1, height: 40, color: Colors.white10),
                    Expanded(
                      child: _SummaryItem(
                        label: 'Non Tunai',
                        value: 'Rp${controller.totalNonCash.value}',
                        icon: Icons.credit_card_rounded,
                        color: AppColors.blue500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppDimens.spacingLg),
            const AppSectionHeader(
              title: 'Konfirmasi Setoran',
              subtitle: 'Catatan dan jumlah fisik sebelum konfirmasi',
            ),
            const SizedBox(height: AppDimens.spacingSm),
            TextField(
              onChanged: controller.setPhysicalCash,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Jumlah uang fisik disetorkan',
                labelStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.money_rounded, color: Colors.white54),
                filled: true,
                fillColor: AppColors.grey800,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
                  borderSide: BorderSide.none,
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
            ),
            const SizedBox(height: AppDimens.spacingMd),
            TextField(
              onChanged: controller.setNote,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Catatan (opsional)',
                labelStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.note_alt_rounded, color: Colors.white54),
                filled: true,
                fillColor: AppColors.grey800,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
                  borderSide: BorderSide.none,
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
            ),
            const SizedBox(height: AppDimens.spacingLg),
            SizedBox(
              width: double.infinity,
              child: Obx(
                () => ElevatedButton(
                  onPressed: controller.loading.value ? null : () => _confirmSubmit(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.orange500,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: AppDimens.spacingMd),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
                    ),
                  ),
                  child: controller.loading.value
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                        )
                      : const Text(
                          'Konfirmasi Tutup Buku',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                ),
              ),
            ),
            const SizedBox(height: AppDimens.spacingXl),
            const AppSectionHeader(
              title: 'Riwayat Tutup Buku',
              subtitle: 'Daftar shift yang sudah ditutup',
            ),
            const SizedBox(height: AppDimens.spacingSm),
            const _ClosingHistory(),
          ],
        ),
      ),
    );
  }

  void _confirmSubmit(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.grey800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.cornerRadius)),
        title: const Text('Konfirmasi', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Apakah Anda yakin ingin menutup buku untuk shift ini? Aksi ini tidak dapat dibatalkan.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.submitClosing();
            },
            child: const Text('Ya, Tutup Buku', style: TextStyle(color: AppColors.orange500)),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  const _SummaryItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: AppDimens.spacingSm),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }
}

class _ClosingHistory extends StatelessWidget {
  const _ClosingHistory();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClosingController>();
    return Obx(() {
      final items = controller.history;
      if (items.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(AppDimens.spacingLg),
            child: Text('Belum ada riwayat', style: TextStyle(color: Colors.white38)),
          ),
        );
      }
      return Column(
        children: items
            .map(
              (i) => Padding(
                padding: const EdgeInsets.only(bottom: AppDimens.spacingSm),
                child: Container(
                  padding: const EdgeInsets.all(AppDimens.spacingMd),
                  decoration: BoxDecoration(
                    color: AppColors.grey800,
                    borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
                    border: Border.all(color: AppColors.grey700),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.orange500.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.history_rounded,
                              color: AppColors.orange500,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: AppDimens.spacingMd),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _format(i.tanggal),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${i.shift} | ${i.karyawan}',
                                style: const TextStyle(color: Colors.white54, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        'Rp${i.total}',
                        style: const TextStyle(
                          color: AppColors.green500,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      );
    });
  }

  String _format(DateTime dt) {
    final t = asLocalTime(dt);
    return '${t.day.toString().padLeft(2, '0')}/${t.month.toString().padLeft(2, '0')}/${t.year} ${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }
}
