import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';

import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_side_drawer.dart';
import '../../../../core/utils/local_time.dart';
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
      actions: [
        IconButton(
          tooltip: 'Tambah pemasukan/pengeluaran',
          onPressed: () => _showAddCashflowSheet(),
          icon: const Icon(Icons.add_circle_outline_rounded),
        ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.orange500,
        foregroundColor: Colors.black,
        onPressed: () => _showAddCashflowSheet(),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah arus kas'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: DefaultTabController(
        length: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _FilterSection(controller: controller),
            const SizedBox(height: AppDimens.spacingMd),
            Container(
              decoration: BoxDecoration(
                color: AppColors.grey800.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
                border: Border.all(color: AppColors.grey700),
              ),
              child: const TabBar(
                isScrollable: true,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.white70,
                indicator: BoxDecoration(
                  color: AppColors.orange500,
                  borderRadius: BorderRadius.all(Radius.circular(AppDimens.cornerRadius)),
                ),
                tabs: [
                  Tab(text: 'Ringkasan'),
                  Tab(text: 'Arus Kas'),
                  Tab(text: 'Karyawan'),
                  Tab(text: 'Pelanggan'),
                  Tab(text: 'Transaksi'),
                ],
              ),
            ),
            const SizedBox(height: AppDimens.spacingMd),
            Expanded(
              child: TabBarView(
                children: [
                  _OverviewTab(controller: controller),
                  _CashflowTab(controller: controller),
                  _StaffTab(controller: controller),
                  _CustomersTab(controller: controller),
                  _TransactionsTab(controller: controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCashflowSheet() {
    Get.bottomSheet<void>(
      Container(
        padding: const EdgeInsets.all(AppDimens.spacingLg),
        decoration: const BoxDecoration(
          color: AppColors.grey900,
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimens.cornerRadius)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tambah arus kas',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16),
              ),
              const SizedBox(height: AppDimens.spacingSm),
              const Text(
                'Catat pemasukan atau pengeluaran non-transaksi.',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: AppDimens.spacingLg),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.trending_up_rounded, color: AppColors.green500),
                title: const Text('Pemasukan (Revenue)', style: TextStyle(color: Colors.white)),
                subtitle: const Text('Contoh: top up kas, penjualan lainnya', style: TextStyle(color: Colors.white54)),
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.financeForm, arguments: EntryType.revenue);
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.trending_down_rounded, color: AppColors.red500),
                title: const Text('Pengeluaran (Expense)', style: TextStyle(color: Colors.white)),
                subtitle: const Text('Contoh: sewa, listrik, belanja operasional', style: TextStyle(color: Colors.white54)),
                onTap: () {
                  Get.back();
                  Get.toNamed(Routes.financeForm, arguments: EntryType.expense);
                },
              ),
              const SizedBox(height: AppDimens.spacingSm),
            ],
          ),
        ),
      ),
    );
  }
}



class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.controller});

  final ReportsController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppDimens.spacingXl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => _HeroProfitCard(netProfit: controller.net)),
            const SizedBox(height: AppDimens.spacingLg),
            const Text(
              'Analisis Keuangan',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
            ),
            const SizedBox(height: AppDimens.spacingMd),
            Obx(() => _ReportsChart(revenue: controller.totalRevenue, expense: controller.totalExpense)),
            const SizedBox(height: AppDimens.spacingLg),
            Obx(
              () => _StatsGrid(
                revenue: controller.totalRevenue,
                expense: controller.totalExpense,
                transactionCount: controller.transactionCount,
              ),
            ),
            const SizedBox(height: AppDimens.spacingLg),
            Obx(() {
              final txCount = controller.transactionCount;
              final paid = controller.paidCount;
              final pending = controller.pendingCount;
              final refund = controller.refundCount;
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppDimens.spacingLg),
                decoration: BoxDecoration(
                  color: AppColors.grey800,
                  borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
                  border: Border.all(color: AppColors.grey700),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ringkasan transaksi',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: AppDimens.spacingSm),
                    Text(
                      'Total: $txCount • Lunas: $paid • Pending: $pending • Refund: $refund',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: AppDimens.spacingMd),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: OutlinedButton.icon(
                        onPressed: () => Get.toNamed(Routes.transactions),
                        icon: const Icon(Icons.receipt_long_rounded),
                        label: const Text('Buka riwayat transaksi'),
                        style: OutlinedButton.styleFrom(side: const BorderSide(color: AppColors.grey700)),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _CashflowTab extends StatelessWidget {
  const _CashflowTab({required this.controller});

  final ReportsController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppDimens.spacingXl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Arus Kas (Revenue/Expense)',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18),
            ),
            const SizedBox(height: AppDimens.spacingSm),
            const Text(
              'Catatan pemasukan/pengeluaran non-transaksi.',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: AppDimens.spacingLg),
            Obx(() {
              final items = controller.filteredEntries;
              if (items.isEmpty) {
                return const AppEmptyState(
                  title: 'Belum ada arus kas',
                  message: 'Tambah pemasukan/pengeluaran untuk melengkapi laporan.',
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (_, index) => const SizedBox(height: AppDimens.spacingSm),
                itemBuilder: (context, index) => _EntryTile(item: items[index]),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _StaffTab extends StatelessWidget {
  const _StaffTab({required this.controller});

  final ReportsController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppDimens.spacingXl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Laporan karyawan',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18),
            ),
            const SizedBox(height: AppDimens.spacingSm),
            const Text(
              'Performa berdasarkan transaksi pada rentang yang dipilih.',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: AppDimens.spacingLg),
            _StylistReportSection(controller: controller),
          ],
        ),
      ),
    );
  }
}

class _CustomersTab extends StatelessWidget {
  const _CustomersTab({required this.controller});

  final ReportsController controller;

  String _formatDate(DateTime dt) {
    dt = asLocalTime(dt);
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppDimens.spacingXl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Laporan pelanggan',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18),
            ),
            const SizedBox(height: AppDimens.spacingSm),
            const Text(
              'Top pelanggan berdasarkan total belanja pada rentang yang dipilih.',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: AppDimens.spacingLg),
            Obx(() {
              final items = controller.customerReports;
              if (items.isEmpty) {
                return const AppEmptyState(
                  title: 'Belum ada data pelanggan',
                  message: 'Pastikan transaksi menyimpan nama pelanggan agar laporan muncul.',
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (_, index) => const SizedBox(height: AppDimens.spacingSm),
                itemBuilder: (context, index) {
                  final c = items[index];
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
                          width: 28,
                          height: 28,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColors.orange500.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(color: AppColors.orange500, fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: AppDimens.spacingMd),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                c.name,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${c.totalTransactions} trx • Terakhir: ${_formatDate(c.lastVisit)}',
                                style: const TextStyle(color: Colors.white54, fontSize: 12),
                              ),
                              if ((c.phone ?? '').trim().isNotEmpty)
                                Text(
                                  c.phone!,
                                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                                ),
                            ],
                          ),
                        ),
                        Text(
                          'Rp${c.totalSpent}',
                          style: const TextStyle(color: AppColors.green500, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _TransactionsTab extends StatelessWidget {
  const _TransactionsTab({required this.controller});

  final ReportsController controller;

  String _formatDateTime(DateTime dt, String time) {
    dt = asLocalTime(dt);
    final d = '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    final t = time.trim().isEmpty ? '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}' : time;
    return '$d $t';
  }

  Color _statusColor(ReportTransactionStatus s) {
    switch (s) {
      case ReportTransactionStatus.paid:
        return AppColors.green500;
      case ReportTransactionStatus.pending:
        return AppColors.orange500;
      case ReportTransactionStatus.refund:
        return AppColors.red500;
    }
  }

  String _statusText(ReportTransactionStatus s) {
    switch (s) {
      case ReportTransactionStatus.paid:
        return 'Lunas';
      case ReportTransactionStatus.pending:
        return 'Pending';
      case ReportTransactionStatus.refund:
        return 'Refund';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppDimens.spacingXl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Laporan transaksi',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18),
            ),
            const SizedBox(height: AppDimens.spacingSm),
            Obx(() {
              final total = controller.transactionCount;
              return Text(
                'Total: $total • Lunas: ${controller.paidCount} • Pending: ${controller.pendingCount} • Refund: ${controller.refundCount}',
                style: const TextStyle(color: Colors.white70),
              );
            }),
            const SizedBox(height: AppDimens.spacingLg),
            Obx(() {
              final items = controller.transactionReports;
              if (items.isEmpty) {
                return const AppEmptyState(
                  title: 'Belum ada transaksi',
                  message: 'Buat transaksi pertama agar laporan transaksi muncul.',
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (_, index) => const SizedBox(height: AppDimens.spacingSm),
                itemBuilder: (context, index) {
                  final tx = items[index];
                  final color = _statusColor(tx.status);
                  return Container(
                    padding: const EdgeInsets.all(AppDimens.spacingMd),
                    decoration: BoxDecoration(
                      color: AppColors.grey800,
                      borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
                      border: Border.all(color: AppColors.grey700),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 5, height: 52, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6))),
                        const SizedBox(width: AppDimens.spacingMd),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      tx.code,
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: color.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(999),
                                      border: Border.all(color: color.withValues(alpha: 0.35)),
                                    ),
                                    child: Text(
                                      _statusText(tx.status),
                                      style: TextStyle(color: color, fontWeight: FontWeight.w700, fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatDateTime(tx.date, tx.time),
                                style: const TextStyle(color: Colors.white54, fontSize: 12),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Rp${tx.amount} • ${tx.paymentMethod} • ${tx.itemsCount} item',
                                style: const TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Pelanggan: ${tx.customerName} • Stylist: ${tx.stylist}',
                                style: const TextStyle(color: Colors.white54, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ],
        ),
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

class _StylistReportSection extends StatelessWidget {
  const _StylistReportSection({required this.controller});

  final ReportsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = controller.stylistReports;
      final shown = items;
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
            ...shown.map(
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
                if (item.transactionCode?.trim().isNotEmpty == true) ...[
                  const SizedBox(height: 2),
                  Text(
                    'TX: ${item.transactionCode!.trim()}',
                    style: const TextStyle(color: Colors.white38, fontSize: 11),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
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
