import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_input_field.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_side_drawer.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/staff_controller.dart';
import '../models/employee_model.dart';

class EmployeeListView extends GetView<StaffController> {
  const EmployeeListView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Karyawan',
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppInputField(
            hint: 'Cari nama atau role',
            prefix: Icon(Icons.search_rounded, color: Colors.white70),
          ),
          const SizedBox(height: AppDimens.spacingLg),
          AppCard(
            backgroundColor: AppColors.grey800,
            borderColor: AppColors.grey700,
            onTap: () => Get.toNamed(Routes.attendanceDaily, arguments: DateTime.now()),
            child: Row(
              children: [
                const Icon(Icons.calendar_month_rounded, color: Colors.white70),
                const SizedBox(width: AppDimens.spacingMd),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Absensi Karyawan',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(height: AppDimens.spacingXs),
                      Text(
                        'Lihat jam check-in/check-out per tanggal',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.white70),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.spacingLg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Daftar Karyawan',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
              TextButton.icon(
                onPressed: () => Get.toNamed(Routes.employeeForm),
                icon: const Icon(Icons.add_rounded, color: AppColors.orange500),
                label: const Text('Tambah', style: TextStyle(color: AppColors.orange500)),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spacingMd),
          Expanded(
            child: Obx(() {
              final items = controller.employees;
              if (items.isEmpty) {
                return AppEmptyState(
                  title: 'Belum ada karyawan',
                  message: 'Tambah karyawan baru untuk mulai mengelola tim.',
                  actionLabel: 'Tambah Karyawan',
                  onAction: () => Get.toNamed(Routes.employeeForm),
                );
              }
              return ListView.separated(
                itemCount: items.length,
                separatorBuilder: (context, _) =>
                    const SizedBox(height: AppDimens.spacingSm),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _EmployeeTile(
                    item: item,
                    onTap: () => Get.toNamed(
                      Routes.employeeDetail,
                      arguments: item.id,
                    ),
                    onToggleStatus: () => controller.toggleStatus(item),
                    onReset: () => controller.resetPassword(item),
                    onDelete: () => _confirmDelete(item),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

void _confirmDelete(Employee item) {
  Get.dialog(
    AlertDialog(
      backgroundColor: AppColors.grey800,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.cornerRadius)),
      title: const Text('Hapus karyawan', style: TextStyle(color: Colors.white)),
      content: Text('Hapus ${item.name}?', style: const TextStyle(color: Colors.white70)),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
        TextButton(
          onPressed: () => Get.find<StaffController>().delete(item),
          child: const Text('Hapus', style: TextStyle(color: AppColors.red500)),
        ),
      ],
    ),
  );
}

class _EmployeeTile extends StatelessWidget {
  const _EmployeeTile({
    required this.item,
    required this.onTap,
    required this.onToggleStatus,
    required this.onReset,
    this.onDelete,
  });

  final Employee item;
  final VoidCallback onTap;
  final VoidCallback onToggleStatus;
  final VoidCallback onReset;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final statusColor = item.status == EmployeeStatus.active ? AppColors.green500 : AppColors.red500;
    return AppCard(
      onTap: onTap,
      backgroundColor: AppColors.grey800,
      borderColor: AppColors.grey700,
      padding: const EdgeInsets.all(AppDimens.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(item.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spacingSm,
                  vertical: AppDimens.spacingXs,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha((0.18 * 255).round()),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  item.status == EmployeeStatus.active ? 'Aktif' : 'Nonaktif',
                  style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spacingXs),
          Text('${item.role} | ${item.phone}', style: const TextStyle(color: Colors.white70)),
          Text(item.email, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: AppDimens.spacingSm),
          Row(
            children: [
              TextButton(
                onPressed: onToggleStatus,
                style: TextButton.styleFrom(foregroundColor: AppColors.orange500),
                child: Text(item.status == EmployeeStatus.active ? 'Nonaktifkan' : 'Aktifkan'),
              ),
              const SizedBox(width: AppDimens.spacingSm),
              TextButton(
                onPressed: onReset,
                style: TextButton.styleFrom(foregroundColor: Colors.white70),
                child: const Text('Reset Password'),
              ),
              if (onDelete != null) ...[
                const SizedBox(width: AppDimens.spacingSm),
                TextButton(
                  onPressed: onDelete,
                  style: TextButton.styleFrom(foregroundColor: AppColors.red500),
                  child: const Text('Hapus'),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
