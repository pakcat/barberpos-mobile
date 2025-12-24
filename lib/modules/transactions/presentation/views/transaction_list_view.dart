import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';

import '../../../../core/widgets/app_input_field.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_side_drawer.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/transaction_controller.dart';
import '../models/transaction_models.dart';

class TransactionListView extends GetView<TransactionController> {
  const TransactionListView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Riwayat Transaksi',
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
        onRefresh: controller.refreshRemote,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _pickRange(context),
                    child: AbsorbPointer(
                      child: Obx(() {
                        final range = controller.filterRange.value;
                        final hint = range == null
                            ? 'Pilih rentang tanggal'
                            : '${_formatShortDate(range.start)} - ${_formatShortDate(range.end)}';
                        return AppInputField(
                          hint: hint,
                          prefix: const Icon(Icons.calendar_month_rounded, color: Colors.white70),
                          suffix: const Icon(Icons.filter_alt_rounded, color: Colors.white70),
                          enabled: false,
                        );
                      }),
                    ),
                  ),
                ),
                Obx(() {
                  if (controller.filterRange.value == null) {
                    return const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(left: AppDimens.spacingSm),
                    child: IconButton(
                      onPressed: controller.clearRange,
                      icon: const Icon(Icons.close_rounded, color: Colors.white70),
                      tooltip: 'Hapus filter',
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: AppDimens.spacingLg),
            Expanded(
              child: Obx(() {
                final items = controller.transactions;
                if (items.isEmpty) {
                  return const AppEmptyState(
                    title: 'Belum ada transaksi',
                    message: 'Transaksi baru akan muncul di sini.',
                  );
                }
                if (controller.loading.value) {
                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, _) => Container(
                      height: 120,
                      margin: const EdgeInsets.only(bottom: AppDimens.spacingSm),
                      decoration: BoxDecoration(
                        color: AppColors.grey800,
                        borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
                      ),
                    ),
                  );
                }
                final grouped = _groupByDate(items);
                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: grouped.length,
                  itemBuilder: (context, index) {
                    final entry = grouped[index];
                    final date = entry.key;
                    final list = entry.value;
                    final total = list.fold<int>(0, (s, t) => s + t.amount);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppDimens.spacingLg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SectionHeader(dateLabel: _formatDate(date), total: total),
                          const SizedBox(height: AppDimens.spacingSm),
                          ...list.map(
                            (tx) => Padding(
                              padding: const EdgeInsets.only(bottom: AppDimens.spacingSm),
                              child: _TransactionTile(
                                item: tx,
                                onTap: () => Get.toNamed(Routes.transactionDetail, arguments: tx.id),
                              ),
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
      ),
    );
  }

  List<MapEntry<DateTime, List<TransactionItem>>> _groupByDate(List<TransactionItem> items) {
    final map = <DateTime, List<TransactionItem>>{};
    for (final tx in items) {
      final key = DateTime(tx.date.year, tx.date.month, tx.date.day);
      map.putIfAbsent(key, () => []).add(tx);
    }
    final entries = map.entries.toList()..sort((a, b) => b.key.compareTo(a.key));
    return entries;
  }

  String _formatDate(DateTime date) {
    const months = [
      '',
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
    return '${_weekday(date.weekday)}, ${date.day.toString().padLeft(2, '0')} ${months[date.month]} ${date.year}';
  }

  String _formatShortDate(DateTime date) {
    const months = [
      '',
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
    return '${date.day.toString().padLeft(2, '0')} ${months[date.month]} ${date.year}';
  }

  String _weekday(int day) {
    switch (day) {
      case DateTime.monday:
        return 'Senin';
      case DateTime.tuesday:
        return 'Selasa';
      case DateTime.wednesday:
        return 'Rabu';
      case DateTime.thursday:
        return 'Kamis';
      case DateTime.friday:
        return 'Jumat';
      case DateTime.saturday:
        return 'Sabtu';
      case DateTime.sunday:
      default:
        return 'Minggu';
    }
  }

  Future<void> _pickRange(BuildContext context) async {
    final now = DateTime.now();
    final initial = controller.filterRange.value ??
        DateTimeRange(
          start: DateTime(now.year, now.month, 1),
          end: now,
        );
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 1),
      initialDateRange: initial,
      helpText: 'Pilih rentang transaksi',
    );
    if (picked != null) {
      await controller.applyRange(picked);
    }
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.dateLabel, required this.total});

  final String dateLabel;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          dateLabel,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        Text(
          'Uang Diterima\nRp$total',
          style: const TextStyle(color: AppColors.orange500),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.item, required this.onTap});

  final TransactionItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isPaid = item.status == TransactionStatus.paid;
    final statusColor = isPaid ? AppColors.green500 : AppColors.orange500;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey800,
        borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
        border: Border.all(color: AppColors.grey700),
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(50), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Status Strip
                Container(width: 6, color: statusColor),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimens.spacingMd),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.id,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              item.time,
                              style: const TextStyle(color: Colors.white54, fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimens.spacingSm),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.grey700,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                item.paymentMethod == 'Tunai'
                                    ? Icons.payments_rounded
                                    : Icons.credit_card_rounded,
                                color: Colors.white70,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: AppDimens.spacingSm),
                            Expanded(
                              child: Text(
                                'Potong Pria, Potong...', // Ideally this should come from the model
                                style: const TextStyle(color: Colors.white70, fontSize: 13),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppDimens.spacingMd),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _StatusPill(status: item.status),
                            Text(
                              'Rp${item.amount}',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final TransactionStatus status;

  @override
  Widget build(BuildContext context) {
    final isPaid = status == TransactionStatus.paid;
    final color = isPaid ? AppColors.green500 : AppColors.orange500;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spacingSm,
        vertical: AppDimens.spacingXs,
      ),
      decoration: BoxDecoration(
        color: color.withAlpha((0.15 * 255).round()),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        isPaid ? 'Lunas' : 'Refund',
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
