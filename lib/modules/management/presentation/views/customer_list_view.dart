import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';

import '../../../../core/widgets/app_input_field.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_side_drawer.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/management_controller.dart';
import '../models/management_models.dart';

class CustomerListView extends GetView<ManagementController> {
  const CustomerListView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Pelanggan',
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
            hint: 'Cari nama, nomor telepon atau email',
            prefix: Icon(Icons.search_rounded, color: Colors.white70),
          ),
          const SizedBox(height: AppDimens.spacingLg),
          const Text(
            'Daftar Pelanggan',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppDimens.spacingMd),
          Expanded(
            child: Obx(() {
              final items = controller.customers;
              if (controller.loading.value) {
                return ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, _) => Container(
                    height: 80,
                    margin: const EdgeInsets.only(bottom: AppDimens.spacingSm),
                    decoration: BoxDecoration(
                      color: AppColors.grey800,
                      borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
                    ),
                  ),
                );
              }
              if (items.isEmpty) {
                return AppEmptyState(
                  title: 'Belum ada pelanggan',
                  message: 'Tambah pelanggan baru untuk mulai menyimpan kontak.',
                  actionLabel: 'Tambah Pelanggan',
                  onAction: () => Get.toNamed(Routes.customerForm),
                );
              }
              return ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, index) => const SizedBox(height: AppDimens.spacingSm),
                itemBuilder: (context, index) {
                  return _CustomerTile(
                    item: items[index],
                    onTap: () => Get.toNamed(Routes.customerForm, arguments: items[index].id),
                    onDelete: () => _confirmDelete(items[index]),
                  );
                },
              );
            }),
          ),
          const SizedBox(height: AppDimens.spacingSm),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Get.toNamed(Routes.customerForm),
              icon: const Icon(Icons.add_rounded, color: Colors.black),
              label: const Text('Tambah Baru', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange500,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: AppDimens.spacingMd),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerTile extends StatelessWidget {
  const _CustomerTile({required this.item, required this.onTap, this.onDelete});

  final CustomerItem item;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  Color _getAvatarColor(String name) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];
    return colors[name.hashCode % colors.length];
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.split(' ');
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final avatarColor = _getAvatarColor(item.name);

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimens.spacingSm),
      decoration: BoxDecoration(
        color: AppColors.grey800,
        borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
        border: Border.all(color: AppColors.grey700),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.spacingMd),
            child: Row(
              children: [
                // Avatar
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: avatarColor.withAlpha(50),
                    shape: BoxShape.circle,
                    border: Border.all(color: avatarColor.withValues(alpha: 0.5), width: 2),
                  ),
                  child: Center(
                    child: Text(
                      _getInitials(item.name),
                      style: TextStyle(
                        color: avatarColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppDimens.spacingMd),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.phone_rounded, color: Colors.white54, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            item.phone,
                            style: const TextStyle(color: Colors.white54, fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Actions
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.call_rounded, color: AppColors.green500),
                      onPressed: () {
                        Get.snackbar('Panggilan', 'Integrasi call akan ditambahkan kemudian.');
                      },
                      tooltip: 'Telepon',
                    ),
                    if (onDelete != null)
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: AppColors.red500),
                        onPressed: onDelete,
                        tooltip: 'Hapus',
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void _confirmDelete(CustomerItem item) {
  Get.dialog(
    AlertDialog(
      backgroundColor: AppColors.grey800,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.cornerRadius)),
      title: const Text('Hapus pelanggan', style: TextStyle(color: Colors.white)),
      content: Text('Hapus ${item.name}?', style: const TextStyle(color: Colors.white70)),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
        TextButton(
          onPressed: () {
            Get.find<ManagementController>().deleteCustomer(item.id);
            Get.back();
            Get.snackbar('Berhasil', 'Pelanggan dihapus');
          },
          child: const Text('Hapus', style: TextStyle(color: AppColors.red500)),
        ),
      ],
    ),
  );
}
