import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_input_field.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_side_drawer.dart';
import '../../../../core/utils/resolve_image_url.dart';
import '../../../../core/widgets/app_image.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/stock_controller.dart';
import '../models/stock_models.dart';

class StockListView extends GetView<StockController> {
  const StockListView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Manajemen Stok',
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
          // Dashboard Summary
          Obx(() {
            final products = controller.products;
            final lowStock = products.where((p) => p.stock <= 5).length;
            return Row(
              children: [
                Expanded(
                  child: _SummaryCard(
                    title: 'Total Produk',
                    value: '${products.length}',
                    icon: Icons.inventory_2_rounded,
                    color: AppColors.blue500,
                  ),
                ),
                const SizedBox(width: AppDimens.spacingMd),
                Expanded(
                  child: _SummaryCard(
                    title: 'Stok Menipis',
                    value: '$lowStock',
                    icon: Icons.warning_rounded,
                    color: AppColors.orange500,
                  ),
                ),
              ],
            );
          }),
          const SizedBox(height: AppDimens.spacingLg),

          const AppInputField(
            hint: 'Cari nama atau kategori',
            prefix: Icon(Icons.search_rounded, color: Colors.white70),
            suffix: Icon(Icons.filter_list_rounded, color: Colors.white70),
          ),
          const SizedBox(height: AppDimens.spacingLg),
          const AppSectionHeader(title: 'Daftar Produk'),
          const SizedBox(height: AppDimens.spacingMd),
          Expanded(
            child: Obx(() {
              final products = controller.products;
              if (products.isEmpty) {
                return AppEmptyState(
                  title: 'Belum ada produk',
                  message: 'Tambah produk untuk mulai mengelola stok.',
                  actionLabel: 'Tambah Produk',
                  onAction: () => Get.toNamed(Routes.productForm),
                );
              }
              return ListView.separated(
                itemCount: products.length,
                separatorBuilder: (_, index) =>
                    const SizedBox(height: AppDimens.spacingSm),
                itemBuilder: (context, index) {
                  return _ProductTile(
                    item: products[index],
                    onTap: () {
                      controller.pickProduct(products[index]);
                      Get.toNamed(Routes.stockDetail);
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: AppDimens.spacingMd),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.item, required this.onTap});

  final StockItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final stockColor = item.stock <= 0
        ? AppColors.red500
        : item.stock <= 5
        ? AppColors.yellow500
        : AppColors.green500;

    return AppCard(
      onTap: onTap,
      backgroundColor: AppColors.grey800,
      borderColor: AppColors.grey700,
      padding: const EdgeInsets.all(AppDimens.spacingSm),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppDimens.cornerRadius / 2),
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
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: AppDimens.spacingXs),
                Text(
                  item.category,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: stockColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: stockColor.withValues(alpha: 0.3)),
            ),
            child: Text(
              '${item.stock} Unit',
              style: TextStyle(
                color: stockColor,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: AppDimens.spacingSm),
          const Icon(Icons.chevron_right_rounded, color: Colors.white54),
        ],
      ),
    );
  }
}
