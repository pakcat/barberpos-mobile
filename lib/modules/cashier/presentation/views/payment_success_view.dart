import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/cashier_controller.dart';
import '../models/checkout_models.dart';

class PaymentSuccessView extends GetView<CashierController> {
  const PaymentSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final method = () {
      switch (controller.paymentMethod.value) {
        case PaymentMethod.cash:
          return 'Tunai';
        case PaymentMethod.nonCash:
          return 'Non Tunai';
        case PaymentMethod.qris:
          return 'QRIS';
        case PaymentMethod.card:
          return 'Kartu';
      }
    }();
    final change = controller.change;
    final total = controller.total;
    final paid = controller.paid;

    return AppScaffold(
      title: 'Pembayaran Berhasil',
      backgroundColor: AppColors.grey900,
      appBarBackgroundColor: Colors.transparent,
      appBarForegroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.close_rounded),
        onPressed: () {
          controller.resetForNewOrder();
          Get.offAllNamed(Routes.cashier);
        },
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimens.padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Icon Animation
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: const BoxDecoration(
                        color: AppColors.green500,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.green500,
                            blurRadius: 20,
                            spreadRadius: 2,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.check_rounded, color: Colors.black, size: 56),
                    ),
                  );
                },
              ),
              const SizedBox(height: AppDimens.spacingXl),

              // Receipt Card
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutExpo,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset(0, 50 * (1 - value)),
                    child: Opacity(opacity: value, child: child),
                  );
                },
                child: Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 400),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(50),
                        blurRadius: 24,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Receipt Header
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppDimens.spacingMd),
                        decoration: const BoxDecoration(
                          color: AppColors.grey100,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(AppDimens.cornerRadius),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'BARBER POS',
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Transaksi Berhasil',
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                      // Zigzag Separator
                      SizedBox(
                        height: 10,
                        width: double.infinity,
                        child: CustomPaint(painter: _ZigZagPainter(color: AppColors.grey100)),
                      ),

                      // Receipt Details
                      Padding(
                        padding: const EdgeInsets.all(AppDimens.spacingLg),
                        child: Column(
                          children: [
                            _ReceiptRow(
                              label: 'Total Tagihan',
                              value: controller.formatCurrency(total),
                              isBold: true,
                            ),
                            const Divider(height: 24, color: AppColors.grey300),
                            _ReceiptRow(label: 'Metode', value: method),
                            _ReceiptRow(label: 'Dibayar', value: controller.formatCurrency(paid)),
                            _ReceiptRow(
                              label: 'Kembalian',
                              value: controller.formatCurrency(change),
                              valueColor: AppColors.green500,
                              isBold: true,
                            ),
                          ],
                        ),
                      ),

                      // Barcode (Visual)
                      Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppDimens.spacingLg,
                          left: AppDimens.spacingLg,
                          right: AppDimens.spacingLg,
                        ),
                        child: Opacity(
                          opacity: 0.6,
                          child: Container(
                            height: 40,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                image: NetworkImage(
                                  'https://upload.wikimedia.org/wikipedia/commons/thumb/8/84/EAN13.svg/1200px-EAN13.svg.png',
                                ), // Placeholder barcode
                                fit: BoxFit.fitWidth,
                                colorFilter: ColorFilter.mode(Colors.black, BlendMode.srcIn),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppDimens.spacingXl),

              // Action Buttons
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Opacity(opacity: value, child: child);
                },
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => Get.snackbar('Cetak', 'Integrasi printer akan ditambahkan.'),
                              icon: const Icon(Icons.print_rounded),
                              label: const Text('Cetak'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white24),
                                padding: const EdgeInsets.symmetric(vertical: AppDimens.spacingMd),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppDimens.spacingMd),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => Get.snackbar('Bagikan', 'Fitur bagikan struk akan ditambahkan.'),
                              icon: const Icon(Icons.share_rounded),
                              label: const Text('Bagikan'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(color: Colors.white24),
                                padding: const EdgeInsets.symmetric(vertical: AppDimens.spacingMd),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimens.spacingMd),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            controller.resetForNewOrder();
                            Get.offAllNamed(Routes.cashier);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.orange500,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: AppDimens.spacingMd),
                            elevation: 4,
                            shadowColor: AppColors.orange500.withAlpha(100),
                          ),
                          child: const Text(
                            'Buat Pesanan Baru',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  const _ReceiptRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black54,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.black87,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              fontSize: isBold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _ZigZagPainter extends CustomPainter {
  final Color color;

  _ZigZagPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    double x = 0;
    double y = 0;
    double step = 10;

    path.moveTo(0, 0);
    while (x < size.width) {
      x += step;
      y = (y == 0) ? step : 0;
      path.lineTo(x, y);
    }
    path.lineTo(size.width, 0);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
