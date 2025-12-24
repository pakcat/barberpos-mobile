import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/printing/receipt_pdf.dart';
import '../../../../core/printing/thermal_printer_service.dart';
import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/utils/local_time.dart';
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
  final TextEditingController refundNoteController = TextEditingController();
  bool refundDelete = true;

  @override
  void dispose() {
    amountController.dispose();
    refundNoteController.dispose();
    super.dispose();
  }

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
          onPressed: () => _showReceiptActions(tx),
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
                  onPressed: () => tx.id.startsWith('PENDING-') ? controller.remove(tx.id) : _confirmRefund(tx.id),
                  child: Text(
                    tx.id.startsWith('PENDING-') ? 'Batalkan (hapus lokal)' : 'Refund & Hapus',
                    style: TextStyle(color: tx.id.startsWith('PENDING-') ? AppColors.orange500 : AppColors.red500),
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.spacingSm),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _markPaid(tx),
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
    date = asLocalTime(date);
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
    refundNoteController.clear();
    refundDelete = true;
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.grey800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.cornerRadius)),
        title: const Text('Konfirmasi refund', style: TextStyle(color: Colors.white)),
        content: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Refund transaksi $id?',
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: AppDimens.spacingSm),
              TextField(
                controller: refundNoteController,
                decoration: const InputDecoration(
                  labelText: 'Catatan (opsional)',
                ),
              ),
              const SizedBox(height: AppDimens.spacingSm),
              SwitchListTile(
                value: refundDelete,
                onChanged: (v) => setState(() => refundDelete = v),
                title: const Text('Hapus dari riwayat', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.refund(id: id, note: refundNoteController.text.trim(), delete: refundDelete);
              Get.snackbar('Refund', refundDelete ? 'Transaksi dihapus & ditandai refund' : 'Transaksi ditandai refund');
              },
            child: const Text('Refund'),
          ),
        ],
      ),
    );
  }

  void _markPaid(TransactionItem tx) {
    controller.markPaid(tx.id);
    Get.snackbar('Status', 'Transaksi ditandai lunas');
  }

  Future<void> _shareReceipt(TransactionItem tx) async {
    final buffer = StringBuffer();
    buffer.writeln('BARBERPOS');
    buffer.writeln('--------------------------');
    buffer.writeln('Kode: ${tx.id}');
    buffer.writeln('Tanggal: ${_formatFullDate(tx.date)} ${tx.time}');
    buffer.writeln('Metode: ${tx.paymentMethod}');
    buffer.writeln('Status: ${tx.status.name}');
    buffer.writeln('--------------------------');
    for (final line in tx.items) {
      buffer.writeln('${line.name} x${line.qty} @ Rp${line.price}');
      buffer.writeln('  Subtotal: Rp${line.price * line.qty}');
    }
    buffer.writeln('--------------------------');
    buffer.writeln('TOTAL: Rp${tx.amount}');
    if (tx.customer.name.trim().isNotEmpty) {
      buffer.writeln('Pelanggan: ${tx.customer.name}');
    }
    await Share.share(buffer.toString());
  }

  Future<void> _showReceiptActions(TransactionItem tx) async {
    await Get.bottomSheet<void>(
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
            children: [
              ListTile(
                leading: const Icon(Icons.text_snippet_rounded, color: Colors.white),
                title: const Text('Bagikan teks', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Get.back();
                  await _shareReceipt(tx);
                },
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf_rounded, color: Colors.white),
                title: const Text('Bagikan PDF', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Get.back();
                  final bytes = await ReceiptPdf.build(tx);
                  await Printing.sharePdf(bytes: bytes, filename: 'receipt_${tx.id}.pdf');
                },
              ),
              ListTile(
                leading: const Icon(Icons.print_rounded, color: Colors.white),
                title: const Text('Print', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Get.back();
                  final bytes = await ReceiptPdf.build(tx);
                  await Printing.layoutPdf(onLayout: (_) async => bytes);
                },
              ),
              ListTile(
                leading: const Icon(Icons.receipt_long_rounded, color: Colors.white),
                title: const Text('Print Thermal (ESC/POS)', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  Get.back();
                  try {
                    await ThermalPrinterService().printReceipt(tx);
                    Get.snackbar('Printer', 'Struk dikirim ke printer');
                  } catch (e) {
                    Get.snackbar('Gagal print', e.toString());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
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
    final isPending = status == TransactionStatus.pending;
    final isPaid = status == TransactionStatus.paid;
    final color = isPending
        ? AppColors.orange500
        : (isPaid ? AppColors.green500 : AppColors.red500);
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
        isPending ? 'Pending' : (isPaid ? 'Lunas' : 'Refund'),
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
