import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/local_time.dart';
import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_side_drawer.dart';
import '../controllers/attendance_controller.dart';

class AttendanceSelfView extends GetView<AttendanceSelfController> {
  const AttendanceSelfView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Absensi',
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
      body: RefreshIndicator(
        onRefresh: controller.refreshToday,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(bottom: AppDimens.spacingXl),
            child: Obx(() {
              final entry = controller.today.value;
              final name = controller.employeeName;
              final today = asLocalTime(DateTime.now());

              final checkIn = entry?.checkIn != null ? asLocalTime(entry!.checkIn!) : null;
              final checkOut = entry?.checkOut != null ? asLocalTime(entry!.checkOut!) : null;
              final hasCheckIn = checkIn != null;
              final hasCheckOut = checkOut != null;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppCard(
                    backgroundColor: AppColors.grey800,
                    borderColor: AppColors.grey700,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name.isEmpty ? 'Absensi Hari Ini' : 'Absensi $name',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppDimens.spacingSm),
                        Text(
                          _formatDate(today),
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: AppDimens.spacingLg),
                        Row(
                          children: [
                            Expanded(
                              child: _InfoTile(
                                label: 'Check-in',
                                value: hasCheckIn ? _hhmm(checkIn) : '-',
                              ),
                            ),
                            const SizedBox(width: AppDimens.spacingMd),
                            Expanded(
                              child: _InfoTile(
                                label: 'Check-out',
                                value: hasCheckOut ? _hhmm(checkOut) : '-',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimens.spacingLg),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: controller.loading.value || hasCheckIn
                                    ? null
                                    : controller.checkIn,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.orange500,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: AppDimens.spacingMd,
                                  ),
                                ),
                                icon: const Icon(Icons.login_rounded),
                                label: const Text('Check-in'),
                              ),
                            ),
                            const SizedBox(width: AppDimens.spacingMd),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: controller.loading.value || !hasCheckIn || hasCheckOut
                                    ? null
                                    : controller.checkOut,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.grey700,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: AppDimens.spacingMd,
                                  ),
                                ),
                                icon: const Icon(Icons.logout_rounded),
                                label: const Text('Check-out'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppDimens.spacingLg),
                  const Text(
                    'Tarik untuk refresh jika status belum berubah.',
                    style: TextStyle(color: Colors.white54),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.grey900,
        borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
          const SizedBox(height: AppDimens.spacingXs),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

String _hhmm(DateTime? t) {
  if (t == null) return '-';
  return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}

String _formatDate(DateTime t) {
  const months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];
  return '${t.day.toString().padLeft(2, '0')} ${months[t.month - 1]} ${t.year}';
}

