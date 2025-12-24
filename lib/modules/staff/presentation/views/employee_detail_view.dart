import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/utils/local_time.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../data/entities/attendance_entity.dart';
import '../../data/repositories/attendance_repository.dart';
import '../controllers/staff_controller.dart';
import '../models/employee_model.dart';

class EmployeeDetailView extends GetView<StaffController> {
  const EmployeeDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final id = Get.arguments as String?;
    final employee = id != null ? controller.getById(id) : null;
    if (employee == null) {
      return const Scaffold(
        body: Center(child: Text('Karyawan tidak ditemukan')),
      );
    }
    return AppScaffold(
      title: 'Detail Karyawan',
      backgroundColor: AppColors.grey900,
      appBarBackgroundColor: Colors.transparent,
      appBarForegroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppCard(
              backgroundColor: AppColors.grey800,
              borderColor: AppColors.grey700,
              padding: const EdgeInsets.all(AppDimens.spacingMd),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.orange500,
                    child: Text(employee.name[0], style: const TextStyle(color: Colors.black)),
                  ),
                  const SizedBox(width: AppDimens.spacingMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(employee.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
                        const SizedBox(height: AppDimens.spacingXs),
                        Text('${employee.role} · ${employee.phone}', style: const TextStyle(color: Colors.white70)),
                        Text(employee.email, style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                  _StatusPill(status: employee.status),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.spacingLg),
            const Text('Performa', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            const SizedBox(height: AppDimens.spacingSm),
            FutureBuilder(
              future: controller.stylistStat(employee.name),
              builder: (context, snapshot) {
                final stat = snapshot.data;
                return Row(
                  children: [
                    _MiniStat(label: 'Transaksi', value: stat?.transaksi.toString() ?? '-'),
                    const SizedBox(width: AppDimens.spacingSm),
                    _MiniStat(label: 'Omzet', value: stat != null ? 'Rp${stat.omzet}' : '-'),
                    const SizedBox(width: AppDimens.spacingSm),
                    _MiniStat(label: 'Item', value: stat?.items.toString() ?? '-'),
                  ],
                );
              },
            ),
            const SizedBox(height: AppDimens.spacingLg),
            const Text('Absensi Bulan Ini',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            const SizedBox(height: AppDimens.spacingSm),
            _AttendanceList(employeeName: employee.name),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final EmployeeStatus status;

  @override
  Widget build(BuildContext context) {
    final color = status == EmployeeStatus.active ? AppColors.green500 : AppColors.red500;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingSm, vertical: AppDimens.spacingXs),
      decoration: BoxDecoration(
        color: color.withAlpha((0.18 * 255).round()),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status == EmployeeStatus.active ? 'Aktif' : 'Nonaktif',
        style: TextStyle(color: color, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppCard(
        backgroundColor: AppColors.grey800,
        borderColor: AppColors.grey700,
        padding: const EdgeInsets.all(AppDimens.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: AppDimens.spacingXs),
            Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}

class _AttendanceList extends StatelessWidget {
  const _AttendanceList({required this.employeeName});

  final String employeeName;

  @override
  Widget build(BuildContext context) {
    final repo = Get.find<AttendanceRepository>();
    final now = DateTime.now();
    return FutureBuilder(
      future: repo.getMonth(employeeName, now),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.all(AppDimens.spacingMd),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final list = snapshot.data!;
        if (list.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(AppDimens.spacingSm),
            child: Text('Belum ada absensi', style: TextStyle(color: Colors.white70)),
          );
        }
        return Column(
          children: list.map((a) {
            final statusColor = {
              AttendanceStatus.present: AppColors.green500,
              AttendanceStatus.leave: AppColors.orange500,
              AttendanceStatus.sick: AppColors.red500,
              AttendanceStatus.off: AppColors.grey500,
            }[a.status]!;
            final d = asLocalTime(a.date);
            final dateLabel = '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
            final inStr = a.checkIn != null
                ? '${asLocalTime(a.checkIn!).hour.toString().padLeft(2, '0')}:${asLocalTime(a.checkIn!).minute.toString().padLeft(2, '0')}'
                : '-';
            final outStr = a.checkOut != null
                ? '${asLocalTime(a.checkOut!).hour.toString().padLeft(2, '0')}:${asLocalTime(a.checkOut!).minute.toString().padLeft(2, '0')}'
                : '-';
            return Padding(
              padding: const EdgeInsets.only(bottom: AppDimens.spacingSm),
              child: AppCard(
                backgroundColor: AppColors.grey800,
                borderColor: AppColors.grey700,
                padding: const EdgeInsets.all(AppDimens.spacingSm),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(dateLabel, style: const TextStyle(color: Colors.white)),
                        const SizedBox(height: 4),
                        Text('Masuk: $inStr | Pulang: $outStr',
                            style: const TextStyle(color: Colors.white70, fontSize: 12)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: statusColor.withAlpha(40),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        a.status.name,
                        style: TextStyle(color: statusColor, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
