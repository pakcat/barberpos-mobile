import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../controllers/transaction_controller.dart';
import '../models/transaction_models.dart';

class TransactionDetailView extends StatefulWidget {
  const TransactionDetailView({super.key});

  @override
  State<TransactionDetailView> createState() => _TransactionDetailViewState();
}

class _TransactionDetailViewState extends State<TransactionDetailView> {
  final controller = Get.find<TransactionController>();
  bool showCustomer = false;
  final TextEditingController amountController = TextEditingController();

  bool get _isRest => Get.find<AppConfig>().backend == BackendMode.rest;

  @override
  Widget build(BuildContext context) {
    final id = Get.arguments as String?;
    final tx = id != null
        ? controller.getById(id)
        : controller.transactions.first;
    if (tx == null) {
      return const Scaffold(
        body: Center(child: Text('Transaksi tidak ditemukan')),
      );
    }
    return AppScaffold(
      title: 'Detail Transaksi',
      backgroundColor: AppColors.grey900,
      appBarBackgroundColor: Colors.transparent,
      appBarForegroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Get.back(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share_rounded),
          onPressed: () => Get.snackbar('Bagikan', 'Struk siap dibagikan.'),
        ),
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Rp${tx.amount}',
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(color: Colors.white),
              ),
              _StatusPill(status: tx.status),
            ],
          ),
          const SizedBox(height: AppDimens.spacingSm),
          Text(
            _formatFullDate(tx.date),
            style: const TextStyle(color: Colors.white70),
          ),
          const Divider(color: AppColors.grey700),
          const Text(
            'Informasi Transaksi',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppDimens.spacingSm),
          AppCard(
            backgroundColor: AppColors.grey800,
            borderColor: AppColors.grey700,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _InfoRow(label: 'Transaksi ID', value: tx.id),
                _InfoRow(label: 'Jam', value: tx.time),
                _InfoRow(label: 'Metode Pembayaran', value: tx.paymentMethod),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.spacingMd),
          Row(
            children: [
              Expanded(
                child: _TabButton(
                  label: 'Pesanan',
                  active: !showCustomer,
                  onTap: () => setState(() => showCustomer = false),
                ),
              ),
              Expanded(
                child: _TabButton(
                  label: 'Pelanggan',
                  active: showCustomer,
                  onTap: () => setState(() => showCustomer = true),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spacingMd),
          Expanded(
            child: SingleChildScrollView(
              child: showCustomer
                  ? _CustomerSection(customer: tx.customer)
                  : _OrderSection(items: tx.items, total: tx.amount),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: _isRest ? () => _notSupported() : () => _confirmRefund(tx.id),
                  child: const Text(
                    'Refund & Hapus',
                    style: TextStyle(color: AppColors.red500),
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.spacingSm),
              Expanded(
                child: OutlinedButton(
                  onPressed: _isRest ? () => _notSupported() : () => _markPaid(tx),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.orange500),
                    foregroundColor: AppColors.orange500,
                  ),
                  child: const Text('Tandai Lunas'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatFullDate(DateTime date) {
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

  void _confirmRefund(String id) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.grey800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.cornerRadius)),
        title: const Text('Konfirmasi refund', style: TextStyle(color: Colors.white)),
        content: Text(
          'Refund transaksi $id?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.remove(id);
              Get.snackbar('Refund', 'Transaksi dihapus & ditandai refund');
              },
            child: const Text('Refund'),
          ),
        ],
      ),
    );
  }

  void _markPaid(TransactionItem tx) {
    controller.upsertTransaction(
      TransactionItem(
        id: tx.id,
        date: tx.date,
        time: tx.time,
        amount: tx.amount,
        paymentMethod: tx.paymentMethod,
        status: TransactionStatus.paid,
        items: tx.items,
        customer: tx.customer,
      ),
    );
    Get.snackbar('Status', 'Transaksi ditandai lunas');
  }

  void _notSupported() {
    Get.snackbar('Info', 'Aksi ini belum tersedia untuk mode REST.');
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.spacingMd),
        decoration: BoxDecoration(
          color: active ? AppColors.orange500 : AppColors.grey800,
          borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: active ? Colors.black : Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.spacingXs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70)),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderSection extends StatelessWidget {
  const _OrderSection({required this.items, required this.total});

  final List<TransactionLine> items;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: AppDimens.spacingSm),
            child: AppCard(
              backgroundColor: AppColors.grey800,
              borderColor: AppColors.grey700,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.spacingSm,
                      vertical: AppDimens.spacingXs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.orange500.withAlpha(
                        (0.15 * 255).round(),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'x${item.qty}',
                      style: const TextStyle(
                        color: AppColors.orange500,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimens.spacingMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: AppDimens.spacingXs),
                        Text(
                          item.category,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Rp${item.price}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Divider(color: AppColors.grey700),
        _InfoRow(label: 'Subtotal', value: 'Rp$total'),
        _InfoRow(label: 'Diskon', value: '-Rp0'),
        _InfoRow(label: 'Pajak', value: '-Rp0'),
        _InfoRow(label: 'Total', value: 'Rp$total'),
      ],
    );
  }
}

class _CustomerSection extends StatelessWidget {
  const _CustomerSection({required this.customer});

  final TransactionCustomer customer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCard(
          backgroundColor: AppColors.grey800,
          borderColor: AppColors.grey700,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Informasi Pesanan',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppDimens.spacingSm),
              const _InfoRow(label: 'Detail Informasi', value: 'Operator'),
              const _InfoRow(label: 'Operator', value: 'Owner'),
            ],
          ),
        ),
        const SizedBox(height: AppDimens.spacingMd),
        AppCard(
          backgroundColor: AppColors.grey800,
          borderColor: AppColors.grey700,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Informasi Pelanggan',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppDimens.spacingSm),
              _InfoRow(label: 'Nama', value: customer.name),
              _InfoRow(label: 'Nomor Telepon', value: customer.phone),
              _InfoRow(label: 'Email', value: customer.email),
              _InfoRow(label: 'Alamat', value: customer.address),
            ],
          ),
        ),
        const SizedBox(height: AppDimens.spacingMd),
        AppCard(
          backgroundColor: AppColors.grey800,
          borderColor: AppColors.grey700,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Riwayat Kunjungan',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppDimens.spacingSm),
              _InfoRow(label: 'Jumlah Kunjungan', value: '${customer.visits}'),
              _InfoRow(
                label: 'Kunjungan Terakhir',
                value: customer.lastVisit ?? '-',
              ),
            ],
          ),
        ),
      ],
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
