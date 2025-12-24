import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_input_field.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/utils/resolve_image_url.dart';
import '../../../../core/widgets/app_image.dart';
import '../controllers/stock_controller.dart';
import '../models/stock_models.dart';

class StockAdjustView extends GetView<StockController> {
  const StockAdjustView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Penyesuaian Stok',
      backgroundColor: AppColors.grey900,
      appBarBackgroundColor: AppColors.grey900,
      appBarForegroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Get.back(),
      ),
      body: Obx(() {
        final list = controller.products;
        final item =
            controller.selected.value ?? (list.isNotEmpty ? list.first : null);
        if (item == null) {
          return const Center(
            child: Text(
              'Belum ada data stok',
              style: TextStyle(color: Colors.white70),
            ),
          );
        }
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppSectionHeader(title: 'Detail Penyesuaian'),
              const SizedBox(height: AppDimens.spacingSm),
              AppCard(
                backgroundColor: AppColors.grey800,
                borderColor: AppColors.grey700,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        AppDimens.cornerRadius / 2,
                      ),
                      child: Builder(
                        builder: (context) {
                          final url = resolveImageUrl(item.image);
                          if (url.isEmpty) {
                            return Container(
                              width: 60,
                              height: 60,
                              color: AppColors.grey700,
                              child: const Icon(
                                Icons.image_not_supported_rounded,
                                color: Colors.white54,
                              ),
                            );
                          }
                          return AppImage(
                            imageUrl: url,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            borderRadius: 0,
                          );
                        },
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Stok Saat ini:',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                        Text(
                          '${item.stock} pcs',
                          style: const TextStyle(
                            color: AppColors.orange500,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimens.spacingLg),
              const Text(
                'Penyesuaian Stok',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: AppDimens.spacingXs),
              DropdownButtonHideUnderline(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.spacingMd,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.grey800,
                    borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
                    border: Border.all(color: AppColors.grey700),
                  ),
                  child: DropdownButton<StockAdjustmentType>(
                    isExpanded: true,
                    dropdownColor: AppColors.grey800,
                    value: controller.adjustmentType.value,
                    hint: const Text(
                      'Pilih',
                      style: TextStyle(color: Colors.white70),
                    ),
                    iconEnabledColor: Colors.white70,
                    style: const TextStyle(color: Colors.white),
                    items: const [
                      DropdownMenuItem(
                        value: StockAdjustmentType.add,
                        child: Text('Penambahan Stok'),
                      ),
                      DropdownMenuItem(
                        value: StockAdjustmentType.reduce,
                        child: Text('Pengurangan Stok'),
                      ),
                      DropdownMenuItem(
                        value: StockAdjustmentType.recount,
                        child: Text('Hitung Ulang Stok'),
                      ),
                    ],
                    onChanged: controller.setAdjustmentType,
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.spacingLg),
              Obx(() {
                final type = controller.adjustmentType.value;
                String label = 'Jumlah Stok';
                if (type == StockAdjustmentType.add) {
                  label = 'Jumlah Penambahan Stok';
                } else if (type == StockAdjustmentType.reduce) {
                  label = 'Jumlah Pengurangan Stok';
                } else if (type == StockAdjustmentType.recount) {
                  label = 'Jumlah Stok Terbaru';
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: const TextStyle(color: Colors.white70)),
                    const SizedBox(height: AppDimens.spacingXs),
                    AppInputField(
                      hint: "Contoh: '6'",
                      keyboardType: TextInputType.number,
                      onChanged: controller.setAdjustmentValue,
                      maxLines: 1,
                    ),
                  ],
                );
              }),
              const SizedBox(height: AppDimens.spacingLg),
              const Text(
                'Catatan (Opsional)',
                style: TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: AppDimens.spacingXs),
              AppInputField(
                hint: 'Masukkan Catatan',
                onChanged: controller.setNote,
                maxLines: 3,
              ),
              const SizedBox(height: AppDimens.spacingXl),
              SizedBox(
                width: double.infinity,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.canSubmit
                        ? controller.submitAdjustment
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange500,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimens.spacingMd,
                      ),
                      disabledBackgroundColor: AppColors.grey700,
                      disabledForegroundColor: Colors.white54,
                    ),
                    child: const Text('Simpan'),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
