import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/local_time.dart';
import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../controllers/attendance_controller.dart';

class AttendanceDailyView extends GetView<AttendanceDailyController> {
  const AttendanceDailyView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Absensi Karyawan',
      backgroundColor: AppColors.grey900,
      appBarBackgroundColor: Colors.transparent,
      appBarForegroundColor: Colors.white,
      onNavigateBack: () async => true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimens.spacingMd),
            child: Row(
              children: [
                Expanded(
                  child: Obx(() {
                    final date = asLocalTime(controller.selectedDate.value);
                    return AppCard(
                      backgroundColor: AppColors.grey800,
                      borderColor: AppColors.grey700,
                      onTap: () => _pickDate(context),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_month_rounded, color: Colors.white70),
                          const SizedBox(width: AppDimens.spacingMd),
                          Expanded(
                            child: Text(
                              _formatDate(date),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const Icon(Icons.chevron_right_rounded, color: Colors.white70),
                        ],
                      ),
                    );
                  }),
                ),
                const SizedBox(width: AppDimens.spacingSm),
                IconButton(
                  tooltip: 'Refresh',
                  onPressed: controller.refreshForSelected,
                  icon: const Icon(Icons.refresh_rounded, color: Colors.white70),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              final items = controller.items;
              if (controller.loading.value && items.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (items.isEmpty) {
                return AppEmptyState(
                  title: 'Belum ada data absensi',
                  message: 'Tidak ada karyawan yang check-in/check-out pada tanggal ini.',
                  actionLabel: 'Refresh',
                  onAction: controller.refreshForSelected,
                );
              }
              return ListView.separated(
                itemCount: items.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppDimens.spacingSm),
                itemBuilder: (context, index) {
                  final a = items[index];
                  final checkIn = a.checkIn != null ? asLocalTime(a.checkIn!) : null;
                  final checkOut = a.checkOut != null ? asLocalTime(a.checkOut!) : null;
                  return AppCard(
                    backgroundColor: AppColors.grey800,
                    borderColor: AppColors.grey700,
                    padding: const EdgeInsets.all(AppDimens.spacingMd),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                a.employeeName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: AppDimens.spacingXs),
                              Text(
                                'Check-in: ${_hhmm(checkIn)}  •  Check-out: ${_hhmm(checkOut)}',
                                style: const TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        if (a.source.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimens.spacingSm,
                              vertical: AppDimens.spacingXs,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              a.source,
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final initial = controller.selectedDate.value;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.orange500,
              surface: AppColors.grey800,
            ),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (picked == null) return;
    await controller.loadDate(picked);
  }
}

String _hhmm(DateTime? t) {
  if (t == null) return '-';
  return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
}

String _formatDate(DateTime t) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];
  return '${t.day.toString().padLeft(2, '0')} ${months[t.month - 1]} ${t.year}';
}
