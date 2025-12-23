import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/widgets/app_input_field.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_side_drawer.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/management_controller.dart';
import '../models/management_models.dart';

class CategoryListView extends GetView<ManagementController> {
  const CategoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Kategori',
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
          const AppInputField(
            hint: 'Cari Kategori',
            prefix: Icon(Icons.search_rounded, color: Colors.white70),
          ),
          const SizedBox(height: AppDimens.spacingLg),
          const Text(
            'Daftar Kategori',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppDimens.spacingMd),
          Expanded(
            child: Obx(() {
              final items = controller.categories;
              if (items.isEmpty) {
                return AppEmptyState(
                  title: 'Belum ada kategori',
                  message: 'Buat kategori layanan atau produk.',
                  actionLabel: 'Tambah Kategori',
                  onAction: () => Get.toNamed(Routes.categoryForm),
                );
              }
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppDimens.spacingMd,
                  mainAxisSpacing: AppDimens.spacingMd,
                  childAspectRatio: 1.5,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return _CategoryCard(
                    item: items[index],
                    onTap: () => Get.toNamed(Routes.categoryForm, arguments: items[index].id),
                  );
                },
              );
            }),
          ),
          const SizedBox(height: AppDimens.spacingSm),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Get.toNamed(Routes.categoryForm),
              icon: const Icon(Icons.add_rounded, color: Colors.black),
              label: const Text('Tambah Baru', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange500,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: AppDimens.spacingMd),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.item, required this.onTap});

  final CategoryItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.grey800, AppColors.grey800.withValues(alpha: 0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
          border: Border.all(color: AppColors.grey700),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -10,
              bottom: -10,
              child: Icon(
                Icons.apps_rounded,
                size: 80,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimens.spacingMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.orange500.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.apps_rounded, color: AppColors.orange500, size: 20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.arrow_forward_rounded, color: Colors.white54, size: 16),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
