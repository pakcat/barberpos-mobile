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

class OrderDetailView extends GetView<CashierController> {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Detail Pesanan',
      backgroundColor: AppColors.grey900,
      appBarBackgroundColor: Colors.transparent,
      appBarForegroundColor: Colors.white,
      leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Get.back()),
      body: Obx(() {
        final items = controller.cart;
        final total = controller.total;
        final customerName = controller.selectedCustomer.value;
        final stylistName = controller.selectedStylist.value;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _CustomerStylistSection(),
              const SizedBox(height: AppDimens.spacingXl),
              const AppSectionHeader(
                title: 'Daftar Pesanan',
                subtitle: 'Ringkas semua layanan yang dipilih',
              ),
              const SizedBox(height: AppDimens.spacingMd),
              ...items.map(
                (item) => _OrderTile(item: item, onRemove: () => controller.removeCartItem(item)),
              ),
              const SizedBox(height: AppDimens.spacingLg),
              const Divider(color: AppColors.grey700),
              const AppSectionHeader(title: 'Ringkasan Pesanan'),
              const SizedBox(height: AppDimens.spacingSm),
              _SummaryRow(label: 'Customer', value: customerName.isEmpty ? '-' : customerName),
              _SummaryRow(label: 'Stylist', value: stylistName.isEmpty ? '-' : stylistName),
              const SizedBox(height: AppDimens.spacingXs),
              _SummaryRow(label: 'Subtotal', value: controller.formatCurrency(total)),
              _SummaryRow(label: 'Diskon', value: controller.formatCurrency(0)),
              _SummaryRow(label: 'Pajak', value: controller.formatCurrency(0)),
              const Divider(color: AppColors.grey700),
              _SummaryRow(
                label: 'Total Pembayaran',
                value: controller.formatCurrency(total),
                isBold: true,
              ),
              const SizedBox(height: AppDimens.spacingXl),
              Padding(
                padding: const EdgeInsets.only(bottom: AppDimens.spacingMd),
                child: Column(
                  children: [
                    TextButton.icon(
                      onPressed: items.isEmpty ? null : controller.cart.clear,
                      icon: const Icon(Icons.delete_outline_rounded, color: AppColors.red500),
                      label: const Text(
                        'Hapus Semua Pesanan',
                        style: TextStyle(color: AppColors.red500),
                      ),
                    ),
                    const SizedBox(height: AppDimens.spacingSm),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: items.isEmpty ? null : () => Get.toNamed(Routes.payment),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.orange500,
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('Lanjutkan'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _CustomerStylistSection extends GetView<CashierController> {
  const _CustomerStylistSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader(
          title: 'Customer & Stylist',
          subtitle: 'Catat pelanggan dan siapa yang menangani',
        ),
        const SizedBox(height: AppDimens.spacingMd),
        AppCard(
          backgroundColor: AppColors.grey800,
          borderColor: AppColors.grey700,
          padding: const EdgeInsets.all(AppDimens.spacingMd),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Customer', style: TextStyle(color: Colors.white70)),
                  TextButton.icon(
                    onPressed: () => _showAddCustomerDialog(context),
                    icon: const Icon(
                      Icons.person_add_alt_1_rounded,
                      size: 18,
                      color: AppColors.orange500,
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.orange500,
                      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingXs),
                    ),
                    label: const Text('Tambah customer'),
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.spacingSm),
              Obx(
                () => DropdownButtonFormField<String>(
                  initialValue: controller.customers.contains(controller.selectedCustomer.value)
                      ? controller.selectedCustomer.value
                      : null,
                  isExpanded: true,
                  dropdownColor: AppColors.grey800,
                  iconEnabledColor: Colors.white70,
                  style: const TextStyle(color: Colors.white),
                  decoration: _inputDecoration('Pilih customer'),
                  items: controller.customers
                      .map(
                        (name) => DropdownMenuItem(
                          value: name,
                          child: Text(name, overflow: TextOverflow.ellipsis),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) controller.setCustomer(value);
                  },
                ),
              ),
              const SizedBox(height: AppDimens.spacingLg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Stylist', style: TextStyle(color: Colors.white70)),
                  TextButton.icon(
                    onPressed: () => Get.toNamed(Routes.stylist),
                    icon: const Icon(
                      Icons.list_alt_rounded,
                      size: 18,
                      color: AppColors.orange500,
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.orange500,
                      padding: const EdgeInsets.symmetric(horizontal: AppDimens.spacingXs),
                    ),
                    label: const Text('Lihat daftar'),
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.spacingSm),
              Obx(
                () {
                  if (controller.stylists.isEmpty) {
                    return const Text(
                      'Belum ada data stylist',
                      style: TextStyle(color: Colors.white54),
                    );
                  }
                  return Wrap(
                    spacing: AppDimens.spacingSm,
                    runSpacing: AppDimens.spacingSm,
                    children: controller.stylists
                        .map(
                          (stylist) => _StylistChip(
                            stylist: stylist,
                            selected: controller.selectedStylist.value == stylist.name,
                            onTap: () => controller.setStylist(stylist.name),
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white38),
      filled: true,
      fillColor: AppColors.grey900,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spacingMd,
        vertical: AppDimens.spacingSm,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
        borderSide: const BorderSide(color: AppColors.grey700),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
        borderSide: const BorderSide(color: AppColors.orange500),
      ),
    );
  }

  void _showAddCustomerDialog(BuildContext context) {
    final textController = TextEditingController();
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.grey800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.cornerRadius)),
        title: const Text('Tambah Customer', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: textController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Nama customer baru',
            hintStyle: TextStyle(color: Colors.white38),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.grey700)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.orange500)),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              final name = textController.text.trim();
              if (name.isEmpty) return;
              if (!controller.customers.contains(name)) {
                controller.customers.add(name);
              }
              controller.setCustomer(name);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.orange500,
              foregroundColor: Colors.black,
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}

class _StylistChip extends StatelessWidget {
  const _StylistChip({required this.stylist, required this.selected, required this.onTap});

  final Stylist stylist;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = selected ? AppColors.orange500 : AppColors.grey700;
    final backgroundColor =
        selected ? AppColors.orange500.withAlpha((0.15 * 255).round()) : AppColors.grey900;
    final textColor = selected ? Colors.white : Colors.white70;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spacingMd,
          vertical: AppDimens.spacingSm,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 14,
              backgroundImage:
                  stylist.avatar.trim().isEmpty ? null : NetworkImage(stylist.avatar),
              child: stylist.avatar.trim().isEmpty
                  ? const Icon(Icons.person_rounded, size: 14, color: Colors.white70)
                  : null,
            ),
            const SizedBox(width: AppDimens.spacingSm),
            Text(
              stylist.name,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (selected) ...[
              const SizedBox(width: AppDimens.spacingXs),
              const Icon(Icons.check_rounded, size: 16, color: AppColors.orange500),
            ],
          ],
        ),
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  const _OrderTile({required this.item, required this.onRemove});

  final CartItem item;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CashierController>();
    return AppCard(
      margin: const EdgeInsets.only(bottom: AppDimens.spacingSm),
      backgroundColor: AppColors.grey800,
      borderColor: AppColors.grey700,
      child: Row(
        children: [
          Row(
            children: [
              _QtyButton(
                icon: Icons.remove_rounded,
                onTap: () => controller.decrementCartItem(item),
                backgroundColor: AppColors.grey800,
                iconColor: Colors.white70,
              ),
              const SizedBox(width: AppDimens.spacingXs),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spacingSm,
                  vertical: AppDimens.spacingXs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.orange500.withAlpha((0.15 * 255).round()),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'x${item.qty}',
                  style: const TextStyle(color: AppColors.orange500, fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: AppDimens.spacingXs),
              _QtyButton(
                icon: Icons.add_rounded,
                onTap: () => controller.incrementCartItem(item),
                backgroundColor: AppColors.orange500,
                iconColor: Colors.black,
              ),
            ],
          ),
          const SizedBox(width: AppDimens.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
                const SizedBox(height: AppDimens.spacingXs),
                Text(item.category, style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ],
            ),
          ),
          Text(
            controller.formatCurrency(item.subtotal),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.close_rounded, color: Colors.white54),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({
    required this.icon,
    required this.onTap,
    required this.backgroundColor,
    required this.iconColor,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.grey700),
        ),
        child: Icon(icon, color: iconColor, size: 18),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value, this.isBold = false});

  final String label;
  final String value;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.spacingXs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
