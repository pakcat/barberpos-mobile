import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_side_drawer.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/reports_controller.dart';
import '../models/report_models.dart';

class ReportsView extends GetView<ReportsController> {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Laporan',
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            return _TabletLayout(controller: controller);
          }
          return _MobileLayout(controller: controller);
        },
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({required this.controller});

  final ReportsController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppDimens.spacingXl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FilterSection(controller: controller),
            const SizedBox(height: AppDimens.spacingLg),
            Obx(() => _HeroProfitCard(netProfit: controller.net)),
            const SizedBox(height: AppDimens.spacingLg),
            const Text(
              'Analisis Keuangan',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
            ),
            const SizedBox(height: AppDimens.spacingMd),
            Obx(
              () =>
                  _ReportsChart(revenue: controller.totalRevenue, expense: controller.totalExpense),
            ),
            const SizedBox(height: AppDimens.spacingLg),
            Obx(
              () => _StatsGrid(
                revenue: controller.totalRevenue,
                expense: controller.totalExpense,
                transactionCount: controller.filteredEntries.length,
              ),
            ),
            const SizedBox(height: AppDimens.spacingLg),
            _StylistReportSection(controller: controller),
            const SizedBox(height: AppDimens.spacingLg),
            _RecentActivitySection(controller: controller),
          ],
        ),
      ),
    );
  }
}

class _TabletLayout extends StatelessWidget {
  const _TabletLayout({required this.controller});

  final ReportsController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.spacingLg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Panel: Dashboard
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _FilterSection(controller: controller),
                  const SizedBox(height: AppDimens.spacingLg),
                  Obx(() => _HeroProfitCard(netProfit: controller.net)),
                  const SizedBox(height: AppDimens.spacingLg),
                  const Text(
                    'Analisis Keuangan',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spacingMd),
                  Obx(
                    () => _ReportsChart(
                      revenue: controller.totalRevenue,
                      expense: controller.totalExpense,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spacingLg),
                  Obx(
                    () => _StatsGrid(
                      revenue: controller.totalRevenue,
                      expense: controller.totalExpense,
                      transactionCount: controller.filteredEntries.length,
                    ),
                  ),
                  const SizedBox(height: AppDimens.spacingLg),
                  _StylistReportSection(controller: controller),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppDimens.spacingXl),
          // Right Panel: Activity List
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(AppDimens.spacingMd),
              decoration: BoxDecoration(
                color: AppColors.grey800.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
                border: Border.all(color: AppColors.grey700),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _RecentActivityHeader(controller: controller),
                  const SizedBox(height: AppDimens.spacingMd),
                  Expanded(
                    child: Obx(() {
                      final items = controller.filteredEntries;
                      if (items.isEmpty) {
                        return const AppEmptyState(
                          title: 'Belum ada data',
                          message: 'Transaksi akan muncul di sini.',
                        );
                      }
                      return ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, index) => const SizedBox(height: AppDimens.spacingSm),
                        itemBuilder: (context, index) => _EntryTile(item: items[index]),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  const _FilterSection({required this.controller});

  final ReportsController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Obx(
        () => Row(
          children: [
            _FilterChip(
              label: 'Hari ini',
              isActive: controller.filterRange.value == 'Hari ini',
              onTap: () => controller.filterRange.value = 'Hari ini',
            ),
            const SizedBox(width: AppDimens.spacingSm),
            _FilterChip(
              label: 'Minggu ini',
              isActive: controller.filterRange.value == 'Minggu ini',
              onTap: () => controller.filterRange.value = 'Minggu ini',
            ),
            const SizedBox(width: AppDimens.spacingSm),
            _FilterChip(
              label: 'Bulan ini',
              isActive: controller.filterRange.value == 'Bulan ini',
              onTap: () => controller.filterRange.value = 'Bulan ini',
            ),
            const SizedBox(width: AppDimens.spacingMd),
            IconButton(
              tooltip: 'Export',
              onPressed: controller.exporting.value
                  ? null
                  : () {
                      Get.dialog(
                        AlertDialog(
                          title: const Text('Export Laporan'),
                          content: const Text('Pilih format file untuk download.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Get.back();
                                controller.downloadExport(format: 'csv');
                              },
                              child: const Text('CSV'),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.back();
                                controller.downloadExport(format: 'xlsx');
                              },
                              child: const Text('Excel (XLSX)'),
                            ),
                          ],
                        ),
                      );
                    },
              icon: controller.exporting.value
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.download_rounded, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecentActivitySection extends StatelessWidget {
  const _RecentActivitySection({required this.controller});

  final ReportsController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _RecentActivityHeader(controller: controller),
        const SizedBox(height: AppDimens.spacingSm),
        Obx(() {
          final items = controller.filteredEntries;
          if (items.isEmpty) {
            return const AppEmptyState(
              title: 'Belum ada data',
              message: 'Transaksi akan muncul di sini.',
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.take(5).length,
            separatorBuilder: (_, index) => const SizedBox(height: AppDimens.spacingSm),
            itemBuilder: (context, index) => _EntryTile(item: items[index]),
          );
        }),
      ],
    );
  }
}

class _StylistReportSection extends StatelessWidget {
  const _StylistReportSection({required this.controller});

  final ReportsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = controller.stylistReports;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Performa Stylist',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
          ),
          const SizedBox(height: AppDimens.spacingSm),
          if (items.isEmpty)
            const AppEmptyState(
              title: 'Belum ada data',
              message: 'Transaksi dengan stylist akan muncul di sini.',
            )
          else
            ...items.take(5).map(
              (s) => Container(
                margin: const EdgeInsets.only(bottom: AppDimens.spacingSm),
                padding: const EdgeInsets.all(AppDimens.spacingSm),
                decoration: BoxDecoration(
                  color: AppColors.grey800,
                  borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
                  border: Border.all(color: AppColors.grey700),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Omzet: Rp${s.totalSales}',
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          Text(
                            'Transaksi: ${s.totalTransactions} | Item: ${s.totalItems}',
                            style: const TextStyle(color: Colors.white54, fontSize: 12),
                          ),
                          if (s.topService != null && s.topService!.isNotEmpty)
                            Text(
                              'Top: ${s.topService}',
                              style: const TextStyle(color: Colors.orangeAccent, fontSize: 12),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
    });
  }
}

class _RecentActivityHeader extends StatelessWidget {
  const _RecentActivityHeader({required this.controller});

  final ReportsController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Riwayat Transaksi',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
        ),
        TextButton(
          onPressed: () => Get.toNamed(Routes.financeForm),
          child: const Text('Tambah', style: TextStyle(color: AppColors.orange500)),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.isActive, required this.onTap});

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.orange500 : AppColors.grey800,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isActive ? AppColors.orange500 : AppColors.grey700),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.white70,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _HeroProfitCard extends StatelessWidget {
  const _HeroProfitCard({required this.netProfit});

  final int netProfit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.spacingLg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.orange500, Colors.deepOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.orange500.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Keuntungan Bersih', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: AppDimens.spacingSm),
          Text(
            'Rp$netProfit',
            style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppDimens.spacingMd),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.trending_up_rounded, color: Colors.white, size: 16),
                SizedBox(width: 4),
                Text(
                  '+12% dari bulan lalu',
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportsChart extends StatelessWidget {
  const _ReportsChart({required this.revenue, required this.expense});

  final int revenue;
  final int expense;

  @override
  Widget build(BuildContext context) {
    final maxVal = (revenue > expense ? revenue : expense).toDouble();
    // Prevent division by zero
    final safeMax = maxVal == 0 ? 1.0 : maxVal;

    return Container(
      height: 200,
      padding: const EdgeInsets.all(AppDimens.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.grey800,
        borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
        border: Border.all(color: AppColors.grey700),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ChartBar(
            label: 'Pemasukan',
            amount: revenue,
            percentage: revenue / safeMax,
            color: AppColors.green500,
          ),
          _ChartBar(
            label: 'Pengeluaran',
            amount: expense,
            percentage: expense / safeMax,
            color: AppColors.red500,
          ),
        ],
      ),
    );
  }
}

class _ChartBar extends StatelessWidget {
  const _ChartBar({
    required this.label,
    required this.amount,
    required this.percentage,
    required this.color,
  });

  final String label;
  final int amount;
  final double percentage;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'Rp${(amount / 1000).toStringAsFixed(0)}k',
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
        const SizedBox(height: 8),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: percentage),
          duration: const Duration(milliseconds: 1000),
          curve: Curves.elasticOut,
          builder: (context, value, _) {
            return Container(
              width: 40,
              height: 100 * value, // Max height 100
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.revenue, required this.expense, required this.transactionCount});

  final int revenue;
  final int expense;
  final int transactionCount;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppDimens.spacingMd,
      crossAxisSpacing: AppDimens.spacingMd,
      childAspectRatio: 1.5,
      children: [
        _StatCard(
          title: 'Total Pemasukan',
          value: 'Rp$revenue',
          icon: Icons.arrow_downward_rounded,
          color: AppColors.green500,
        ),
        _StatCard(
          title: 'Total Pengeluaran',
          value: 'Rp$expense',
          icon: Icons.arrow_upward_rounded,
          color: AppColors.red500,
        ),
        _StatCard(
          title: 'Total Transaksi',
          value: '$transactionCount',
          icon: Icons.receipt_long_rounded,
          color: AppColors.blue500,
        ),
        _StatCard(
          title: 'Rata-rata Order',
          value: transactionCount == 0 ? '-' : 'Rp${(revenue / transactionCount).round()}',
          icon: Icons.analytics_rounded,
          color: AppColors.yellow500,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.grey800,
        borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
        border: Border.all(color: AppColors.grey700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 20),
              Icon(Icons.more_horiz, color: Colors.white24, size: 16),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(color: Colors.white54, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }
}

class _EntryTile extends StatelessWidget {
  const _EntryTile({required this.item});

  final FinanceEntry item;

  @override
  Widget build(BuildContext context) {
    final isRevenue = item.type == EntryType.revenue;
    final color = isRevenue ? AppColors.green500 : AppColors.red500;
    final icon = isRevenue ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded;

    return Container(
      padding: const EdgeInsets.all(AppDimens.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.grey800,
        borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
        border: Border.all(color: AppColors.grey700),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: AppDimens.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDate(item.date),
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            '${isRevenue ? '+' : '-'} Rp${item.amount}',
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}
