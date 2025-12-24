import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_input_field.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_side_drawer.dart';
import '../controllers/membership_controller.dart';
import '../models/membership_models.dart';

class MembershipView extends GetView<MembershipController> {
  const MembershipView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Membership',
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
        child: Padding(
          padding: const EdgeInsets.only(bottom: AppDimens.spacingXl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppSectionHeader(
                title: 'Kuota Membership',
                subtitle:
                    'Pantau kuota transaksi per bulan dan top-up tambahan',
              ),
              const SizedBox(height: AppDimens.spacingMd),
              Obx(() {
                final isStaff = controller.isStaff;
                if (isStaff) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _QuotaCard(
                        title: 'Sisa Kuota',
                        value: controller.formatNumber(
                          controller.remainingQuota,
                        ),
                        caption: 'Kuota yang bisa dipakai hari ini',
                        accentColor: AppColors.green500,
                        progress: controller.usageProgress,
                      ),
                      const SizedBox(height: AppDimens.spacingSm),
                      const Text(
                        'Hubungi manager untuk menambah kuota top-up.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  );
                }

                return Wrap(
                  spacing: AppDimens.spacingMd,
                  runSpacing: AppDimens.spacingMd,
                  children: [
                    _QuotaCard(
                      title: 'Sisa Kuota',
                      value: controller.formatNumber(controller.remainingQuota),
                      caption: 'Kuota tersedia untuk transaksi',
                      accentColor: AppColors.green500,
                      progress: controller.usageProgress,
                    ),
                    _QuotaCard(
                      title: 'Dipakai Bulan Ini',
                      value: controller.formatNumber(
                        controller.usedQuota.value,
                      ),
                      caption:
                          'Dari total ${controller.formatNumber(controller.totalQuota)}',
                      accentColor: AppColors.orange500,
                      progress: controller.usageProgress,
                      invertProgress: true,
                    ),
                    _QuotaCard(
                      title: 'Kuota Gratis',
                      value: controller.formatNumber(
                        controller.freeQuota.value,
                      ),
                      caption: 'Reset setiap awal bulan',
                      accentColor: AppColors.blue500,
                      progress: controller.totalQuota == 0
                          ? 0
                          : controller.freeQuota.value / controller.totalQuota,
                    ),
                    _QuotaCard(
                      title: 'Kuota Top-up',
                      value: controller.formatNumber(controller.topupQuota),
                      caption: 'Ditambahkan oleh manager',
                      accentColor: AppColors.yellow500,
                      progress: controller.topupQuota == 0
                          ? 0
                          : controller.topupQuota / controller.totalQuota,
                    ),
                  ],
                );
              }),
              const SizedBox(height: AppDimens.spacingXl),
              Obx(() {
                if (controller.isStaff) {
                  return const SizedBox.shrink();
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSectionHeader(
                      title: 'Top-up Kuota',
                      subtitle: 'Manager dapat menambah kuota ekstra',
                      trailing: Chip(
                        label: Text(
                          'Total top-up: ${controller.formatNumber(controller.topupQuota)}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        backgroundColor: AppColors.orange500,
                      ),
                    ),
                    const SizedBox(height: AppDimens.spacingMd),
                    AppCard(
                      backgroundColor: AppColors.grey800,
                      borderColor: AppColors.grey700,
                      child: Column(
                        children: [
                          AppInputField(
                            controller: controller.amountController,
                            hint: 'Nominal kuota (cth: 250)',
                            keyboardType: TextInputType.number,
                            prefix: const Icon(
                              Icons.confirmation_number_rounded,
                            ),
                          ),
                          const SizedBox(height: AppDimens.spacingSm),
                          AppInputField(
                            controller: controller.noteController,
                            hint: 'Catatan (opsional)',
                            maxLines: 2,
                            prefix: const Icon(Icons.sticky_note_2_outlined),
                          ),
                          const SizedBox(height: AppDimens.spacingSm),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: controller.addTopup,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.orange500,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppDimens.spacingMd,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppDimens.cornerRadius,
                                  ),
                                ),
                              ),
                              icon: const Icon(Icons.add_card_rounded),
                              label: const Text('Tambah Top-up'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimens.spacingXl),
                  ],
                );
              }),
              AppSectionHeader(
                title: 'Riwayat Top-up',
                subtitle: 'Pantau top-up terakhir dan catatannya',
                trailing: Obx(
                  () => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.spacingSm,
                      vertical: AppDimens.spacingXs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.grey800,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: AppColors.grey700),
                    ),
                    child: Text(
                      '${controller.topups.length} entri',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.spacingMd),
              Obx(() {
                if (controller.topups.isEmpty) {
                  return const AppEmptyState(
                    title: 'Belum ada top-up',
                    message:
                        'Manager bisa menambahkan kuota ekstra kapan saja.',
                  );
                }
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.topups.length,
                  separatorBuilder: (_, index) =>
                      const SizedBox(height: AppDimens.spacingSm),
                  itemBuilder: (context, index) {
                    final topup = controller.topups[index];
                    return _TopupTile(
                      topup: topup,
                      formattedAmount: controller.formatNumber(topup.amount),
                      formattedDate: controller.formatDate(topup.date),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuotaCard extends StatelessWidget {
  const _QuotaCard({
    required this.title,
    required this.value,
    required this.caption,
    required this.accentColor,
    this.progress,
    this.invertProgress = false,
  });

  final String title;
  final String value;
  final String caption;
  final Color accentColor;
  final double? progress;
  final bool invertProgress;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 260,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              accentColor.withValues(alpha: 0.2),
              AppColors.grey800.withValues(alpha: 0.5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
          border: Border.all(color: accentColor.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: accentColor.withValues(alpha: 0.1),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    Icons.pie_chart_rounded,
                    color: accentColor.withValues(alpha: 0.8),
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.spacingLg),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimens.spacingXs),
              Text(
                caption,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 12,
                ),
              ),
              if (progress != null) ...[
                const SizedBox(height: AppDimens.spacingMd),
                Stack(
                  children: [
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.black26,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: invertProgress
                          ? 1 - progress!.clamp(0, 1)
                          : progress!.clamp(0, 1),
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: accentColor,
                          borderRadius: BorderRadius.circular(999),
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withValues(alpha: 0.5),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _TopupTile extends StatelessWidget {
  const _TopupTile({
    required this.topup,
    required this.formattedAmount,
    required this.formattedDate,
  });

  final QuotaTopup topup;
  final String formattedAmount;
  final String formattedDate;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      backgroundColor: AppColors.grey800,
      borderColor: AppColors.grey700,
      padding: const EdgeInsets.all(AppDimens.spacingMd),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimens.spacingSm),
            decoration: BoxDecoration(
              color: AppColors.orange500.withAlpha((0.16 * 255).round()),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.workspace_premium_rounded,
              color: AppColors.orange500,
            ),
          ),
          const SizedBox(width: AppDimens.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${topup.manager} menambah $formattedAmount kuota',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDimens.spacingXs),
                Text(topup.note, style: const TextStyle(color: Colors.white70)),
                const SizedBox(height: AppDimens.spacingXs),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      color: Colors.white54,
                      size: 14,
                    ),
                    const SizedBox(width: AppDimens.spacingXs),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimens.spacingSm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.spacingSm,
              vertical: AppDimens.spacingXs,
            ),
            decoration: BoxDecoration(
              color: AppColors.grey700,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              '$formattedAmount kuota',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
