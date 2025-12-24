import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/auth_service.dart';
import '../values/app_colors.dart';
import '../values/app_dimens.dart';
import '../values/app_strings.dart';
import '../../routes/app_routes.dart';
import '../../modules/staff/presentation/models/employee_model.dart';

class AppSideDrawer extends StatelessWidget {
  const AppSideDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthService>();
    return Drawer(
      child: Container(
        color: AppColors.grey900,
        child: SafeArea(
          child: Obx(() {
            final isManager = auth.isManager;
            final isStaff = auth.isStaffOnly;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: AppDimens.spacingLg),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/logo/logo.png',
                        height: 60,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.cut_rounded,
                          size: 40,
                          color: AppColors.orange500,
                        ),
                      ),
                      const SizedBox(width: AppDimens.spacingMd),
                      Text(
                        AppStrings.appName.toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                const Divider(color: AppColors.grey800, height: 1),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(AppDimens.spacingLg),
                    children: [
                      if (isManager)
                        const _DrawerItem(
                          icon: Icons.dashboard_rounded,
                          label: 'Dashboard',
                          route: Routes.home,
                        ),
                      if (isManager || (isStaff && auth.staffCan(EmployeeModuleKeys.cashier)))
                        const _DrawerItem(
                          icon: Icons.storefront_rounded,
                          label: 'Kasir',
                          route: Routes.cashier,
                        ),
                      if (isStaff)
                        const _DrawerItem(
                          icon: Icons.task_alt_rounded,
                          label: 'Absensi',
                          route: Routes.attendance,
                        ),
                      if (isManager || (isStaff && auth.staffCan(EmployeeModuleKeys.transactions)))
                        const _DrawerItem(
                          icon: Icons.receipt_long_rounded,
                          label: 'Transaksi',
                          route: Routes.transactions,
                        ),
                      if (isManager || (isStaff && auth.staffCan(EmployeeModuleKeys.customers)))
                        const _DrawerItem(
                          icon: Icons.groups_rounded,
                          label: 'Pelanggan',
                          route: Routes.customers,
                        ),
                      if (isManager || isStaff)
                        const _DrawerItem(
                          icon: Icons.card_membership_rounded,
                          label: 'Membership',
                          route: Routes.membership,
                        ),
                      if (isManager)
                        const _DrawerItem(
                          icon: Icons.bar_chart_rounded,
                          label: 'Laporan',
                          route: Routes.reports,
                        ),
                      if (isManager)
                        const _DrawerItem(
                          icon: Icons.design_services_rounded,
                          label: 'Layanan/Produk',
                          route: Routes.products,
                        ),
                      if (isManager)
                        const _DrawerItem(
                          icon: Icons.category_rounded,
                          label: 'Kategori',
                          route: Routes.categories,
                        ),
                      if (isManager)
                        const _DrawerItem(
                          icon: Icons.inventory_2_rounded,
                          label: 'Stok',
                          route: Routes.stock,
                        ),
                      if (isManager)
                        const _DrawerItem(
                          icon: Icons.people_alt_rounded,
                          label: 'Karyawan',
                          route: Routes.employees,
                        ),
                      if (isManager || (isStaff && auth.staffCan(EmployeeModuleKeys.closing)))
                        const _DrawerItem(
                          icon: Icons.lock_clock_rounded,
                          label: 'Tutup Buku',
                          route: Routes.closing,
                        ),
                      if (isManager)
                        const _DrawerItem(
                          icon: Icons.history_rounded,
                          label: 'Log Aktivitas',
                          route: Routes.activityLogs,
                        ),
                      if (isManager)
                        const _DrawerItem(
                          icon: Icons.cloud_sync_rounded,
                          label: 'Sinkronisasi',
                          route: Routes.sync,
                        ),
                      if (isStaff)
                        const _DrawerItem(
                          icon: Icons.cloud_sync_rounded,
                          label: 'Sinkronisasi',
                          route: Routes.sync,
                        ),
                      if (isManager)
                        const _DrawerItem(
                          icon: Icons.settings_rounded,
                          label: 'Pengaturan',
                          route: Routes.settings,
                        ),
                      const SizedBox(height: AppDimens.spacingLg),
                      ListTile(
                        leading: const Icon(Icons.logout_rounded, color: Colors.white70),
                        title: const Text(
                          'Logout',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                        onTap: () => _confirmLogout(auth),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

void _confirmLogout(AuthService auth) {
  Get.dialog(
    AlertDialog(
      backgroundColor: AppColors.grey800,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.cornerRadius)),
      title: const Text('Konfirmasi', style: TextStyle(color: Colors.white)),
      content: const Text(
        'Apakah Anda yakin ingin logout? Pastikan data sudah tersimpan.',
        style: TextStyle(color: Colors.white70),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
        TextButton(
          onPressed: () async {
            await auth.logout();
            Get.offAllNamed(Routes.login);
          },
          child: const Text('Logout'),
        ),
      ],
    ),
  );
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({required this.icon, required this.label, required this.route});

  final IconData icon;
  final String label;
  final String route;

  @override
  Widget build(BuildContext context) {
    final isActive = Get.currentRoute == route;
    final color = isActive ? AppColors.orange500 : Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        label,
        style: TextStyle(color: color, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.cornerRadius)),
      tileColor: isActive ? AppColors.grey800 : Colors.transparent,
      onTap: () {
        Get.back();
        if (Get.currentRoute != route) {
          Get.offAllNamed(route);
        }
      },
    );
  }
}
