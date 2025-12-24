import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_input_field.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_side_drawer.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/utils/resolve_image_url.dart';
import '../../../../core/widgets/app_image.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/product_controller.dart';
import '../models/product_models.dart';

class ProductListView extends GetView<ProductController> {
  const ProductListView({super.key});

  Future<void> _confirmDelete(BuildContext context, ProductItem item) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: AppColors.grey800,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
        ),
        title: const Text(
          'Hapus produk?',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Produk "${item.name}" akan dihapus. Lanjutkan?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (result == true) {
      await controller.deleteProduct(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Daftar Produk',
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
          final isTablet = constraints.maxWidth >= AppDimens.tabletBreakpoint;
          final crossAxisCount = isTablet ? 4 : 2;
          final childAspectRatio = isTablet ? 0.75 : 0.65;

          return RefreshIndicator(
            color: AppColors.orange500,
            onRefresh: controller.refreshRemote,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: AppInputField(
                              hint: 'Cari nama atau kategori',
                              prefix: Icon(
                                Icons.search_rounded,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppDimens.spacingSm),
                          Obx(
                            () => _ViewToggle(
                              mode: controller.viewMode.value,
                              onChange: controller.setViewMode,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimens.spacingLg),
                      const Text(
                        'Daftar Produk',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppDimens.spacingMd),
                    ],
                  ),
                ),
                Obx(() {
                  final items = controller.products;
                  final isGrid =
                      controller.viewMode.value == ProductViewMode.grid;
                  if (controller.loading.value) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppDimens.spacingXl,
                        ),
                        child: Column(
                          children: List.generate(
                            4,
                            (i) => Container(
                              margin: const EdgeInsets.only(
                                bottom: AppDimens.spacingSm,
                              ),
                              height: isGrid ? 180 : 90,
                              decoration: BoxDecoration(
                                color: AppColors.grey800,
                                borderRadius: BorderRadius.circular(
                                  AppDimens.cornerRadius,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  if (items.isEmpty) {
                    return SliverFillRemaining(
                      hasScrollBody: false,
                      child: AppEmptyState(
                        title: 'Belum ada produk',
                        message: 'Tambahkan produk untuk mulai berjualan.',
                        actionLabel: 'Tambah Produk',
                        onAction: () => Get.toNamed(Routes.productForm),
                      ),
                    );
                  }
                  if (isGrid) {
                    return SliverPadding(
                      padding: const EdgeInsets.only(
                        bottom: AppDimens.spacingLg,
                      ),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: AppDimens.spacingLg,
                          mainAxisSpacing: AppDimens.spacingLg,
                          childAspectRatio: childAspectRatio,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _ProductCard(
                            item: items[index],
                            onEdit: () => Get.toNamed(
                              Routes.productForm,
                              arguments: items[index].id,
                            ),
                            onDelete: () =>
                                _confirmDelete(context, items[index]),
                          ),
                          childCount: items.length,
                        ),
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.only(bottom: AppDimens.spacingLg),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => Padding(
                          padding: EdgeInsets.only(
                            bottom: index == items.length - 1
                                ? 0
                                : AppDimens.spacingSm,
                          ),
                          child: _ProductRow(
                            item: items[index],
                            onEdit: () => Get.toNamed(
                              Routes.productForm,
                              arguments: items[index].id,
                            ),
                            onDelete: () =>
                                _confirmDelete(context, items[index]),
                          ),
                        ),
                        childCount: items.length,
                      ),
                    ),
                  );
                }),
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SizedBox(height: AppDimens.spacingMd),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => Get.toNamed(Routes.productForm),
                          icon: const Icon(
                            Icons.add_rounded,
                            color: Colors.black,
                          ),
                          label: const Text(
                            'Tambah Baru',
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.orange500,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppDimens.spacingMd,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimens.spacingXl),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ViewToggle extends StatelessWidget {
  const _ViewToggle({required this.mode, required this.onChange});

  final ProductViewMode mode;
  final ValueChanged<ProductViewMode> onChange;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.grey800,
        borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
        border: Border.all(color: AppColors.grey700),
      ),
      child: Row(
        children: [
          _ToggleButton(
            icon: Icons.view_list_rounded,
            active: mode == ProductViewMode.list,
            onTap: () => onChange(ProductViewMode.list),
          ),
          _ToggleButton(
            icon: Icons.grid_view_rounded,
            active: mode == ProductViewMode.grid,
            onTap: () => onChange(ProductViewMode.grid),
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  const _ToggleButton({
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
      child: Container(
        padding: const EdgeInsets.all(AppDimens.spacingSm),
        decoration: BoxDecoration(
          color: active ? AppColors.orange500 : Colors.transparent,
          borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
        ),
        child: Icon(
          icon,
          color: active ? Colors.black : Colors.white70,
          size: 18,
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  final ProductItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onEdit,
      backgroundColor: AppColors.grey800,
      borderColor: AppColors.grey700,
      padding: EdgeInsets.zero, // Removed padding for cleaner look
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppDimens.cornerRadius),
            ),
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Builder(
                    builder: (context) {
                      final url = resolveImageUrl(item.image);
                      if (url.isEmpty) {
                        return Container(
                          color: AppColors.grey700,
                          child: const Icon(
                            Icons.image_not_supported_rounded,
                            color: Colors.white54,
                          ),
                        );
                      }
                      return AppImage(
                        imageUrl: url,
                        fit: BoxFit.cover,
                        borderRadius: 0,
                      );
                    },
                  ),
                ),
                Positioned(
                  top: AppDimens.spacingSm,
                  left: AppDimens.spacingSm,
                  child: _SyncPill(status: item.syncStatus),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppDimens.spacingMd),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: AppDimens.spacingXs),
                Text(
                  item.category,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const SizedBox(height: AppDimens.spacingSm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rp${item.price}',
                      style: const TextStyle(
                        color: AppColors.orange500,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: onEdit,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.orange500.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.edit_rounded,
                              size: 16,
                              color: AppColors.orange500,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppDimens.spacingSm),
                        InkWell(
                          onTap: onDelete,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.red500.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.delete_rounded,
                              size: 16,
                              color: AppColors.red500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductRow extends StatelessWidget {
  const _ProductRow({
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  final ProductItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onEdit,
      backgroundColor: AppColors.grey800,
      borderColor: AppColors.grey700,
      padding: const EdgeInsets.all(AppDimens.spacingSm),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            height: 70,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimens.cornerRadius / 2),
              child: Builder(
                builder: (context) {
                  final url = resolveImageUrl(item.image);
                  if (url.isEmpty) {
                    return Container(
                      color: AppColors.grey700,
                      child: const Icon(
                        Icons.image_not_supported_rounded,
                        color: Colors.white54,
                      ),
                    );
                  }
                  return AppImage(
                    imageUrl: url,
                    fit: BoxFit.cover,
                    width: 70,
                    height: 70,
                    borderRadius: 0,
                  );
                },
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
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: AppDimens.spacingXs),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.category,
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppDimens.spacingSm),
                    _SyncPill(status: item.syncStatus, compact: true),
                  ],
                ),
              ],
            ),
          ),
          Text(
            'Rp${item.price}',
            style: const TextStyle(
              color: AppColors.orange500,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: AppDimens.spacingSm),
          Row(
            children: [
              TextButton(
                onPressed: onEdit,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.orange500,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.spacingSm,
                    vertical: AppDimens.spacingXs,
                  ),
                  minimumSize: Size.zero,
                ),
                child: const Text('Ubah'),
              ),
              IconButton(
                icon: const Icon(Icons.delete_rounded, color: AppColors.red500),
                onPressed: onDelete,
                tooltip: 'Hapus produk',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SyncPill extends StatelessWidget {
  const _SyncPill({required this.status, this.compact = false});

  final ProductSyncStatus status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (status == ProductSyncStatus.synced) return const SizedBox.shrink();

    final isPending = status == ProductSyncStatus.pending;
    final color = isPending ? AppColors.orange500 : AppColors.red500;
    final text = isPending ? 'Pending' : 'Gagal';
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: compact ? 11 : 12,
        ),
      ),
    );
  }
}
