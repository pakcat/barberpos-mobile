import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/app_input_field.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../controllers/reports_controller.dart';
import '../models/report_models.dart';

class FinanceFormView extends StatefulWidget {
  const FinanceFormView({super.key});

  @override
  State<FinanceFormView> createState() => _FinanceFormViewState();
}

class _FinanceFormViewState extends State<FinanceFormView> {
  final ReportsController controller = Get.find<ReportsController>();

  EntryType type = EntryType.revenue;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController categoryController = TextEditingController(
    text: 'Operasional',
  );
  final TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final arg = Get.arguments;
    if (arg is EntryType) {
      type = arg;
    } else if (arg is String) {
      final normalized = arg.trim().toLowerCase();
      type = normalized == 'expense' ? EntryType.expense : EntryType.revenue;
    }
  }

  Future<void> save() async {
    final title = titleController.text.trim();
    final amount = int.tryParse(amountController.text.trim()) ?? 0;
    if (title.isEmpty || amount <= 0) return;
    final synced = await controller.addEntry(
      FinanceEntry(
        id: DateTime.now().toIso8601String(),
        title: title,
        amount: amount,
        category: categoryController.text.trim().isEmpty
            ? 'Lainnya'
            : categoryController.text.trim(),
        date: DateTime.now(),
        type: type,
        note: noteController.text.trim(),
      ),
    );
    Get.back();
    Get.snackbar(
      'Arus kas',
      synced ? 'Tersimpan & tersinkron ke server.' : 'Disimpan lokal (belum tersinkron).',
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Tambah Arus Kas',
      backgroundColor: AppColors.grey900,
      appBarBackgroundColor: AppColors.grey900,
      appBarForegroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Get.back(),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AppChip(
                  label: 'Revenue',
                  active: type == EntryType.revenue,
                  onTap: () => setState(() => type = EntryType.revenue),
                ),
                const SizedBox(width: AppDimens.spacingSm),
                AppChip(
                  label: 'Expense',
                  active: type == EntryType.expense,
                  onTap: () => setState(() => type = EntryType.expense),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.spacingLg),
            const Text('Judul *', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: AppDimens.spacingXs),
            AppInputField(
              hint: type == EntryType.revenue
                  ? 'Masukkan judul pemasukan'
                  : 'Masukkan judul pengeluaran',
              controller: titleController,
            ),
            const SizedBox(height: AppDimens.spacingMd),
            const Text('Jumlah *', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: AppDimens.spacingXs),
            AppInputField(
              hint: 'Masukkan nominal',
              keyboardType: TextInputType.number,
              controller: amountController,
            ),
            const SizedBox(height: AppDimens.spacingMd),
            const Text('Kategori', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: AppDimens.spacingXs),
            AppInputField(
              hint: 'Operasional / Kas / Produk',
              controller: categoryController,
            ),
            const SizedBox(height: AppDimens.spacingMd),
            const Text('Catatan', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: AppDimens.spacingXs),
            AppInputField(
              hint: 'Tuliskan detail',
              controller: noteController,
              maxLines: 3,
            ),
            const SizedBox(height: AppDimens.spacingXl),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => save(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.orange500,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppDimens.spacingMd,
                  ),
                ),
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
