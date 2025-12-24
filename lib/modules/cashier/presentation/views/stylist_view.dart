import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/cashier_controller.dart';
import '../models/checkout_models.dart';

class StylistView extends GetView<CashierController> {
  const StylistView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Pilih Stylist',
      backgroundColor: AppColors.grey900,
      appBarBackgroundColor: Colors.transparent,
      appBarForegroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_rounded),
        onPressed: () => Get.back(),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppSectionHeader(
            title: 'Daftar Stylist',
            subtitle: 'Pilih stylist yang handle pelanggan ini',
          ),
          const SizedBox(height: AppDimens.spacingMd),
          Expanded(
            child: ListView.separated(
              itemCount: controller.stylists.length,
              separatorBuilder: (_, index) =>
                  const SizedBox(height: AppDimens.spacingSm),
              itemBuilder: (context, index) {
                final stylist = controller.stylists[index];
                return Obx(
                  () => _StylistTile(
                    stylist: stylist,
                    selected: controller.selectedStylist.value == stylist.name,
                    onTap: () => controller.setStylist(stylist.name),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppDimens.spacingMd),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.toNamed(Routes.payment),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange500,
                foregroundColor: Colors.black,
              ),
              child: const Text('Lanjutkan'),
            ),
          ),
        ],
      ),
    );
  }
}

class _StylistTile extends StatelessWidget {
  const _StylistTile({
    required this.stylist,
    required this.selected,
    required this.onTap,
  });

  final Stylist stylist;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      backgroundColor: AppColors.grey800,
      borderColor: selected ? AppColors.orange500 : AppColors.grey700,
      padding: const EdgeInsets.all(AppDimens.spacingMd),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage:
                stylist.avatar.trim().isEmpty ? null : NetworkImage(stylist.avatar),
            child: stylist.avatar.trim().isEmpty
                ? const Icon(Icons.person_rounded, color: Colors.white70)
                : null,
          ),
          const SizedBox(width: AppDimens.spacingMd),
          Expanded(
            child: Text(
              stylist.name,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
          ),
          Container(
            height: 18,
            width: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? AppColors.orange500 : Colors.white54,
                width: 2,
              ),
            ),
            child: selected
                ? Container(
                    margin: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.orange500,
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
