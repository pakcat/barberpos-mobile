import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../controllers/cashier_controller.dart';
import '../models/checkout_models.dart';

class PaymentView extends GetView<CashierController> {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Pembayaran',
      backgroundColor: AppColors.grey900,
      appBarBackgroundColor: Colors.transparent,
      appBarForegroundColor: Colors.white,
      leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Get.back()),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth > 600;

          if (isTablet) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: Summary
                const Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.only(right: AppDimens.spacingLg),
                    child: _PaymentSummary(),
                  ),
                ),
                // Vertical Divider
                Container(
                  width: 1,
                  color: AppColors.grey700,
                  margin: const EdgeInsets.symmetric(horizontal: AppDimens.spacingMd),
                ),
                // Right: Keypad
                Expanded(
                  flex: 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _Keypad(
                            onTap: controller.appendPaymentInput,
                            onClearAll: controller.clearPaymentInput,
                            onDelete: controller.removeLastPaymentDigit,
                            onPay: controller.checkout,
                          ),
                        ],
                      ),
                    ),
                  ],
            );
          }

          // Mobile Layout
          return Column(
            children: [
              const Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: AppDimens.spacingMd),
                  child: _PaymentSummary(),
                ),
              ),
              const SizedBox(height: AppDimens.spacingMd),
              _Keypad(
                onTap: controller.appendPaymentInput,
                onClearAll: controller.clearPaymentInput,
                onDelete: controller.removeLastPaymentDigit,
                onPay: controller.checkout,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PaymentSummary extends GetView<CashierController> {
  const _PaymentSummary();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final total = controller.total;
      final paid = controller.paid;
      final change = controller.change;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Total Tagihan', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: AppDimens.spacingXs),
          Text(
            controller.formatCurrency(total),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: AppDimens.spacingLg),
          Wrap(
            spacing: AppDimens.spacingSm,
            runSpacing: AppDimens.spacingSm,
            children: [
              Obx(
                () => AppChip(
                  label: 'Tunai',
                  active: controller.paymentMethod.value == PaymentMethod.cash,
                  onTap: () => controller.setPaymentMethod(PaymentMethod.cash),
                ),
              ),
              Obx(
                () => AppChip(
                  label: 'Non Tunai',
                  active: controller.paymentMethod.value == PaymentMethod.nonCash,
                  onTap: () => controller.setPaymentMethod(PaymentMethod.nonCash),
                ),
              ),
              Obx(
                () => AppChip(
                  label: 'QRIS',
                  active: controller.paymentMethod.value == PaymentMethod.qris,
                  onTap: () => controller.setPaymentMethod(PaymentMethod.qris),
                ),
              ),
              Obx(
                () => AppChip(
                  label: 'Kartu',
                  active: controller.paymentMethod.value == PaymentMethod.card,
                  onTap: () => controller.setPaymentMethod(PaymentMethod.card),
                ),
              ),
            ],
          ),
          const Divider(color: AppColors.grey700, height: 32),
          const Text('Total Diterima', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: AppDimens.spacingSm),
          Container(
            padding: const EdgeInsets.all(AppDimens.spacingMd),
            decoration: BoxDecoration(
              color: AppColors.grey800,
              borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
              border: Border.all(color: AppColors.grey700),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    controller.formatCurrency(paid),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white),
                  ),
                ),
                if (change >= 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.spacingSm,
                      vertical: AppDimens.spacingXs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.green500.withAlpha((0.12 * 255).round()),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Kembali ${controller.formatCurrency(change)}',
                      style: const TextStyle(color: AppColors.green500, fontSize: 12),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.spacingSm,
                      vertical: AppDimens.spacingXs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.red500.withAlpha((0.12 * 255).round()),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      'Kurang ${controller.formatCurrency(change.abs())}',
                      style: const TextStyle(color: AppColors.red500, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppDimens.spacingMd),
          Wrap(
            spacing: AppDimens.spacingSm,
            runSpacing: AppDimens.spacingSm,
            children: [
              _QuickAmountButton(
                label: 'Rp50.000',
                onTap: () => controller.setPaymentInput('50000'),
              ),
              _QuickAmountButton(
                label: 'Rp75.000',
                onTap: () => controller.setPaymentInput('75000'),
              ),
              _QuickAmountButton(
                label: 'Rp100.000',
                onTap: () => controller.setPaymentInput('100000'),
              ),
            ],
          ),
        ],
      );
    });
  }
}

class _QuickAmountButton extends StatelessWidget {
  const _QuickAmountButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppChip(label: label, onTap: onTap);
  }
}

class _Keypad extends StatelessWidget {
  const _Keypad({
    required this.onTap,
    required this.onClearAll,
    required this.onDelete,
    required this.onPay,
  });

  final ValueChanged<String> onTap;
  final VoidCallback onClearAll;
  final VoidCallback onDelete;
  final Future<void> Function()? onPay;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CashierController>();
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '000', '0', 'AC'];

    return Obx(() {
      final paid = controller.paid;
      final total = controller.total;
      final canPay = paid >= total;
      final loading = controller.processingPayment.value;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: AppDimens.spacingSm,
              crossAxisSpacing: AppDimens.spacingSm,
              childAspectRatio: MediaQuery.of(context).size.width > 600 ? 1.8 : 1.5,
            ),
            itemCount: keys.length + 1,
            itemBuilder: (context, index) {
              if (index == keys.length) {
                return _KeyButton(
                  label: 'DEL',
                  onTap: onDelete,
                  backgroundColor: AppColors.grey800,
                );
              }
              final label = keys[index];
              if (label == 'AC') {
                return _KeyButton(
                  label: label,
                  onTap: onClearAll,
                  backgroundColor: AppColors.grey800,
                  textColor: Colors.orange,
                );
              }
              return _KeyButton(
                label: label,
                onTap: () => onTap(label),
                backgroundColor: AppColors.grey700,
                textColor: Colors.white,
              );
            },
          ),
          const SizedBox(height: AppDimens.spacingSm),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: canPay && !loading
                  ? () async {
                      if (onPay != null) await onPay!();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    canPay && !loading ? AppColors.orange500 : AppColors.grey700,
                foregroundColor: canPay && !loading ? Colors.black : Colors.white54,
                padding: const EdgeInsets.symmetric(vertical: AppDimens.spacingMd),
              ),
              child: loading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                    )
                  : const Text('Bayar'),
            ),
          ),
        ],
      );
    });
  }
}

class _KeyButton extends StatelessWidget {
  const _KeyButton({
    required this.label,
    required this.onTap,
    this.backgroundColor,
    this.textColor,
  });

  final String label;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.grey800,
          borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
          border: Border.all(color: AppColors.grey700),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(color: textColor ?? Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
