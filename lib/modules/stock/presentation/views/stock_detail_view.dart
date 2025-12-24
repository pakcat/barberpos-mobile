import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/utils/resolve_image_url.dart';
import '../../../../core/widgets/app_image.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/stock_controller.dart';
import '../models/stock_models.dart';

class StockDetailView extends GetView<StockController> {
  const StockDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final item = controller.selected.value ?? controller.products.first;
    return AppScaffold(
      title: 'Detail Produk',
      backgroundColor: AppColors.grey900,
      appBarBackgroundColor: AppColors.grey900,
      appBarForegroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Get.back(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
            child: Builder(
              builder: (context) {
                final url = resolveImageUrl(item.image);
                if (url.isEmpty) {
                  return Container(
                    height: 220,
                    color: AppColors.grey800,
                    child: const Icon(
                      Icons.image_not_supported_rounded,
                      color: Colors.white54,
                    ),
                  );
                }
                return AppImage(
                  imageUrl: url,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  borderRadius: 0,
                );
              },
            ),
          ),
          const SizedBox(height: AppDimens.spacingLg),
          Text(
            item.name,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: AppDimens.spacingXs),
          const Text('Haircut', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: AppDimens.spacingLg),
          Row(
            children: [
              Expanded(
                child: AppCard(
                  backgroundColor: AppColors.grey800,
                  borderColor: AppColors.grey700,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.inventory_2_rounded,
                        color: Colors.white70,
                      ),
                      const SizedBox(height: AppDimens.spacingSm),
                      const Text(
                        'Stok Tersedia',
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: AppDimens.spacingXs),
                      Text(
                        '${item.stock} pcs',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppDimens.spacingSm),
              Expanded(
                child: AppCard(
                  backgroundColor: AppColors.grey800,
                  borderColor: AppColors.grey700,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.receipt_long_rounded,
                        color: Colors.white70,
                      ),
                      const SizedBox(height: AppDimens.spacingSm),
                      const Text(
                        'Transaksi',
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: AppDimens.spacingXs),
                      Text(
                        '${item.transactions}',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spacingLg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Riwayat Stok',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppChip(label: 'Februari 2025'),
            ],
          ),
          const SizedBox(height: AppDimens.spacingSm),
          Expanded(
            child: Obx(() {
              final history = controller.histories;
              if (history.isEmpty) {
                return RefreshIndicator(
                  color: AppColors.orange500,
                  onRefresh: controller.refreshRemote,
                  child: ListView(
                    children: const [
                      SizedBox(height: AppDimens.spacingXl),
                      AppEmptyState(
                        title: 'Belum ada riwayat',
                        message:
                            'Riwayat stok akan muncul setelah penyesuaian.',
                      ),
                    ],
                  ),
                );
              }
              return RefreshIndicator(
                color: AppColors.orange500,
                onRefresh: controller.refreshRemote,
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: history.length,
                  separatorBuilder: (_, index) =>
                      const SizedBox(height: AppDimens.spacingXs),
                  itemBuilder: (context, index) {
                    final item = history[index];
                    return _HistoryRow(item: item);
                  },
                ),
              );
            }),
          ),
          const SizedBox(height: AppDimens.spacingMd),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.toNamed(Routes.stockAdjust),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange500,
                foregroundColor: Colors.black,
              ),
              child: const Text('Sesuaikan Stok'),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  const _HistoryRow({required this.item});

  final StockHistory item;

  Color getColor() {
    switch (item.type) {
      case StockAdjustmentType.add:
        return AppColors.green500;
      case StockAdjustmentType.reduce:
        return AppColors.red500;
      case StockAdjustmentType.recount:
        return AppColors.blue500;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = getColor();
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimens.spacingSm,
        horizontal: AppDimens.spacingMd,
      ),
      decoration: BoxDecoration(
        color: AppColors.grey800,
        borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
        border: Border.all(color: AppColors.grey700),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Text(
              item.date,
              style: const TextStyle(color: Colors.white70),
            ),
          ),
          Expanded(
            child: Text(
              item.status,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            width: 70,
            child: Text(
              '${item.quantity > 0 ? '+' : ''}${item.quantity}',
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: AppDimens.spacingSm),
          SizedBox(
            width: 50,
            child: Text(
              '${item.remaining}',
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
