import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/values/app_strings.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_side_drawer.dart';
import '../../../../routes/app_routes.dart';
import '../controllers/home_controller.dart';
import '../../../dashboard/presentation/controllers/dashboard_controller.dart';
import '../../../transactions/presentation/controllers/transaction_controller.dart';
import '../../../transactions/presentation/models/transaction_models.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final dash = Get.put(DashboardController(), permanent: true);
    final tx = Get.put(TransactionController(), permanent: true);
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= AppDimens.tabletBreakpoint;
        return AppScaffold(
          title: AppStrings.homeTitle,
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
          actions: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none_rounded),
                  onPressed: () => Get.toNamed(Routes.notifications),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.red500,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ],
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimens.spacingXl),
                _SummaryGrid(isTablet: isTablet, maxWidth: constraints.maxWidth, controller: dash),
                const SizedBox(height: AppDimens.spacingXl),
                _SalesSection(isTablet: isTablet, controller: dash),
                const SizedBox(height: AppDimens.spacingXl),
                _TopLists(controller: dash, isTablet: isTablet),
                const SizedBox(height: AppDimens.spacingXl),
                _TransactionsSection(controller: tx),
                const SizedBox(height: AppDimens.spacingXl),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.isTablet, required this.maxWidth, required this.controller});

  final bool isTablet;
  final double maxWidth;
  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = isTablet ? 4 : 2;
    final spacing = AppDimens.spacingXl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.dailySummary,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
        ),
        const SizedBox(height: AppDimens.spacingLg),
        Obx(() {
          final items = [
            _SummaryCardData(
              title: AppStrings.todayTransactions,
              value: '${controller.summary['transaksiHariIni'] ?? '-'}',
              subtitle: AppStrings.vsYesterday,
              icon: Icons.receipt_long_rounded,
              color: AppColors.orange500,
              isPositive: true,
            ),
            _SummaryCardData(
              title: AppStrings.todayRevenue,
              value: 'Rp${controller.summary['omzetHariIni'] ?? '-'}',
              subtitle: AppStrings.vsYesterday,
              icon: Icons.attach_money_rounded,
              color: AppColors.green500,
              isPositive: true,
            ),
            _SummaryCardData(
              title: AppStrings.todayCustomers,
              value: '${controller.summary['customerHariIni'] ?? '-'}',
              subtitle: AppStrings.vsYesterday,
              icon: Icons.people_alt_rounded,
              color: AppColors.yellow500,
              isPositive: true,
            ),
            _SummaryCardData(
              title: AppStrings.servicesSold,
              value: '${controller.summary['layananTerjual'] ?? '-'}',
              subtitle: AppStrings.vsYesterday,
              icon: Icons.content_cut_rounded,
              color: AppColors.orange400,
              isPositive: true,
            ),
          ];
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              childAspectRatio: isTablet ? 1.5 : 1.3,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) => _SummaryCard(data: items[index], isTablet: isTablet),
          );
        }),
      ],
    );
  }
}

class _SummaryCardData {
  const _SummaryCardData({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.isPositive = true,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isPositive;
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.data, required this.isTablet});

  final _SummaryCardData data;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
        child: Container(
          padding: const EdgeInsets.all(AppDimens.spacingLg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
            gradient: const LinearGradient(
              colors: [AppColors.grey800, AppColors.grey700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: AppColors.grey800),
            boxShadow: const [
              BoxShadow(color: Color(0x33000000), blurRadius: 10, offset: Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: data.color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(data.icon, color: data.color, size: 20),
                  ),
                  const SizedBox(width: AppDimens.spacingMd),
                  Expanded(
                    child: Text(
                      data.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.spacingLg),
              Text(
                data.value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontSize: isTablet ? 22 : 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppDimens.spacingXs),
              Row(
                children: [
                  Icon(
                    data.isPositive ? Icons.arrow_drop_up_rounded : Icons.arrow_drop_down_rounded,
                    color: data.isPositive ? AppColors.green500 : AppColors.red500,
                    size: 20,
                  ),
                  const SizedBox(width: AppDimens.spacingXs),
                  Expanded(
                    child: Text(
                      data.subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SalesSection extends StatelessWidget {
  const _SalesSection({required this.isTablet, required this.controller});

  final bool isTablet;
  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.salesChart,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
            Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spacingMd,
                  vertical: AppDimens.spacingSm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.grey800,
                  borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_month_rounded, size: 18, color: Colors.white70),
                    const SizedBox(width: AppDimens.spacingSm),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: AppColors.grey800,
                        value: controller.filterRange.value,
                        items: const [
                          DropdownMenuItem(value: 'Hari ini', child: Text('Hari ini')),
                          DropdownMenuItem(value: 'Minggu ini', child: Text('Minggu ini')),
                          DropdownMenuItem(value: 'Bulan ini', child: Text('Bulan ini')),
                        ],
                        onChanged: (v) {
                          if (v != null) controller.load(range: v);
                        },
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spacingLg),
        Container(
          padding: const EdgeInsets.all(AppDimens.spacingLg),
          decoration: BoxDecoration(
            color: AppColors.grey800,
            borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
            border: Border.all(color: AppColors.grey700),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: const [_FilterChip(label: AppStrings.salesChart, isActive: true)]),
              const SizedBox(height: AppDimens.spacingLg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        AppStrings.totalSales,
                        style: TextStyle(color: Colors.white70, fontSize: 13),
                      ),
                      const SizedBox(height: AppDimens.spacingXs),
                      Text(
                        'Rp${controller.summary['omzetHariIni'] ?? '-'}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontSize: isTablet ? 26 : 24,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.spacingSm,
                      vertical: AppDimens.spacingXs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.green500Low,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  child: Obx(() {
                    final percent = controller.summary['growthPercent'];
                    final valueText = percent is num
                        ? '${percent.toStringAsFixed(1)}% dibanding minggu lalu'
                        : '-';
                    return Row(
                      children: [
                        const Icon(Icons.trending_up_rounded, size: 14, color: AppColors.green500),
                        const SizedBox(width: AppDimens.spacingXs),
                        Text(
                          valueText,
                          style: const TextStyle(color: AppColors.green500, fontSize: 12),
                        ),
                      ],
                    );
                  }),
                ),
                ],
              ),
              const SizedBox(height: AppDimens.spacingLg),
              Obx(
                () => SizedBox(
                  height: isTablet ? 260 : 220,
                  child: _SalesChart(
                    data: controller.salesSeries
                        .map((e) => (e['value'] as num).toDouble())
                        .toList(),
                    labels: controller.salesSeries.map((e) => e['label'] as String).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TopLists extends StatelessWidget {
  const _TopLists({required this.controller, required this.isTablet});

  final DashboardController controller;
  final bool isTablet;

  @override
  Widget build(BuildContext context) {
    if (isTablet) {
      return _TabletTopLists(controller: controller);
    }

    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.top5,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
              Text(
                'Rentang: ${controller.filterRange.value}',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spacingLg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _TopCard(
                  title: AppStrings.topServices,
                  items: controller.topServices
                      .map(
                        (i) => _TopItem(
                          rank: controller.topServices.indexOf(i) + 1,
                          title: i['name'],
                          subtitle: "${i['qty']}x | Rp${i['amount']}",
                          icon: Icons.cut_rounded,
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(width: AppDimens.spacingLg),
              Expanded(
                child: _TopCard(
                  title: AppStrings.topStaff,
                  items: controller.topStaff
                      .map(
                        (i) => _TopItem(
                          rank: controller.topStaff.indexOf(i) + 1,
                          title: i['name'],
                          subtitle: "${i['role']} | ${i['transaksi'] ?? '-'} trx",
                          icon: Icons.person_rounded,
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TabletTopLists extends StatelessWidget {
  const _TabletTopLists({required this.controller});

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.top5,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
              Text(
                'Rentang: ${controller.filterRange.value}',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spacingLg),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _PodiumSection(
                  title: AppStrings.topServices,
                  icon: Icons.cut_rounded,
                  items: controller.topServices
                      .map(
                        (i) => _TopItem(
                          rank: controller.topServices.indexOf(i) + 1,
                          title: i['name'],
                          subtitle: "${i['qty']}x",
                          value: "Rp${i['amount']}",
                          icon: Icons.cut_rounded,
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(width: AppDimens.spacingLg),
              Expanded(
                child: _PodiumSection(
                  title: AppStrings.topStaff,
                  icon: Icons.person_rounded,
                  items: controller.topStaff
                      .map(
                        (i) => _TopItem(
                          rank: controller.topStaff.indexOf(i) + 1,
                          title: i['name'],
                          subtitle: "${i['role']}",
                          value: "${i['transaksi'] ?? '-'} Trx",
                          icon: Icons.person_rounded,
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PodiumSection extends StatelessWidget {
  const _PodiumSection({required this.title, required this.icon, required this.items});

  final String title;
  final IconData icon;
  final List<_TopItem> items;

  @override
  Widget build(BuildContext context) {
    final top3 = items.take(3).toList();
    final rest = items.skip(3).toList();

    // Reorder for podium: 2nd, 1st, 3rd
    final podiumItems = <_TopItem?>[null, null, null];
    if (top3.isNotEmpty) podiumItems[1] = top3[0]; // 1st in center
    if (top3.length > 1) podiumItems[0] = top3[1]; // 2nd on left
    if (top3.length > 2) podiumItems[2] = top3[2]; // 3rd on right

    return Container(
      padding: const EdgeInsets.all(AppDimens.spacingLg),
      decoration: BoxDecoration(
        color: AppColors.grey800,
        borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
        border: Border.all(color: AppColors.grey700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.orange500, size: 20),
              const SizedBox(width: AppDimens.spacingSm),
              Text(
                title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spacingXl),
          // Podium
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (podiumItems[0] != null)
                  Expanded(child: _PodiumItem(item: podiumItems[0]!, position: 2)),
                if (podiumItems[1] != null)
                  Expanded(child: _PodiumItem(item: podiumItems[1]!, position: 1)),
                if (podiumItems[2] != null)
                  Expanded(child: _PodiumItem(item: podiumItems[2]!, position: 3)),
              ],
            ),
          ),
          if (rest.isNotEmpty) ...[
            const SizedBox(height: AppDimens.spacingLg),
            const Divider(color: Colors.white10),
            const SizedBox(height: AppDimens.spacingMd),
            // List for the rest
            ...rest.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: AppDimens.spacingSm),
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(color: Colors.white10, shape: BoxShape.circle),
                      child: Text(
                        '${item.rank}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppDimens.spacingSm),
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(color: Colors.white70),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      item.value ?? item.subtitle,
                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PodiumItem extends StatelessWidget {
  const _PodiumItem({required this.item, required this.position});

  final _TopItem item;
  final int position;

  @override
  Widget build(BuildContext context) {
    final isFirst = position == 1;
    final color = isFirst
        ? AppColors.orange500
        : (position == 2 ? const Color(0xFFC0C0C0) : const Color(0xFFCD7F32)); // Silver, Bronze
    final height = isFirst ? 140.0 : 110.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Avatar/Icon
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
          ),
          child: Icon(item.icon, color: color, size: isFirst ? 32 : 24),
        ),
        const SizedBox(height: 8),
        Text(
          item.title,
          style: TextStyle(
            color: Colors.white,
            fontWeight: isFirst ? FontWeight.bold : FontWeight.w500,
            fontSize: isFirst ? 14 : 12,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          item.value ?? '',
          style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // Podium Block
        Container(
          height: height - 50, // Adjusted to prevent overflow
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [color.withValues(alpha: 0.3), color.withValues(alpha: 0.05)],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            border: Border(top: BorderSide(color: color, width: 2)),
          ),
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            '$position',
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Outfit', // Assuming font
            ),
          ),
        ),
      ],
    );
  }
}

class _TopCard extends StatelessWidget {
  const _TopCard({required this.title, required this.items});

  final String title;
  final List<_TopItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.spacingLg),
      decoration: BoxDecoration(
        color: AppColors.grey800,
        borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
        border: Border.all(color: AppColors.grey700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppDimens.spacingSm),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimens.spacingSm),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${item.rank}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimens.spacingSm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          item.subtitle,
                          style: const TextStyle(color: Colors.white54, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopItem {
  final int rank;
  final String title;
  final String subtitle;
  final String? value;
  final IconData icon;

  _TopItem({
    required this.rank,
    required this.title,
    required this.subtitle,
    this.value,
    required this.icon,
  });
}

class _SalesChart extends StatelessWidget {
  const _SalesChart({required this.data, required this.labels});

  final List<double> data;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CustomPaint(
            painter: _ChartPainter(
              data: data,
              lineColor: AppColors.orange500,
              fillColor: AppColors.orange500.withValues(alpha: 0.12),
            ),
            child: const SizedBox.expand(),
          ),
        ),
        const SizedBox(height: AppDimens.spacingSm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: labels.map((label) {
            // Shorten "Minggu" to "M" to prevent overflow
            final shortLabel = label.replaceAll(RegExp(r'Minggu', caseSensitive: false), 'M');
            return Text(shortLabel, style: const TextStyle(color: Colors.white70, fontSize: 12));
          }).toList(),
        ),
      ],
    );
  }
}

class _ChartPainter extends CustomPainter {
  _ChartPainter({required this.data, required this.lineColor, required this.fillColor});

  final List<double> data;
  final Color lineColor;
  final Color fillColor;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    final maxValue = data.reduce(max);
    final minValue = data.reduce(min);
    final range = max(maxValue - minValue, 0.1);
    final dx = size.width / (data.length - 1);

    final linePath = Path();
    final fillPath = Path()..moveTo(0, size.height);

    for (int i = 0; i < data.length; i++) {
      final x = dx * i;
      final normalized = (data[i] - minValue) / range;
      final y = size.height - normalized * size.height;

      if (i == 0) {
        linePath.moveTo(x, y);
        fillPath.lineTo(x, y);
      } else {
        linePath.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        colors: [fillColor, Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(linePath, linePaint);

    final dotPaint = Paint()..color = lineColor;
    for (int i = 0; i < data.length; i++) {
      final x = dx * i;
      final normalized = (data[i] - minValue) / range;
      final y = size.height - normalized * size.height;
      canvas.drawCircle(Offset(x, y), 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.fillColor != fillColor;
  }
}

class _TransactionsSection extends StatelessWidget {
  const _TransactionsSection({required this.controller});

  final TransactionController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.recentTransactions,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
            TextButton(
              onPressed: () => Get.toNamed(Routes.transactions),
              child: const Text(AppStrings.seeAll, style: TextStyle(color: AppColors.orange500)),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.spacingMd),
        Container(
          decoration: BoxDecoration(
            color: AppColors.grey800,
            borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
            border: Border.all(color: AppColors.grey700),
          ),
          child: Obx(() {
            final recent = controller.transactions.take(5).map(_map).toList();
            if (recent.isEmpty) {
              return const Padding(
                padding: EdgeInsets.all(AppDimens.spacingMd),
                child: Text(
                  'Belum ada transaksi',
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }
            return Column(
              children: [
                for (int i = 0; i < recent.length; i++) ...[
                  _TransactionCard(tx: recent[i]),
                  if (i != recent.length - 1) const Divider(height: 1, color: Colors.white10),
                ],
              ],
            );
          }),
        ),
      ],
    );
  }

  _TransactionItem _map(TransactionItem tx) {
    final firstItem = tx.items.isNotEmpty ? tx.items.first : null;
    final title = firstItem?.name ?? tx.id;
    final subtitle = firstItem?.category ?? '';
    final statusColor = tx.status == TransactionStatus.paid ? AppColors.green500 : AppColors.red500;
    final statusLabel = tx.status == TransactionStatus.paid ? 'Lunas' : 'Refund';
    final timeLabel = tx.time;
    return _TransactionItem(
      id: tx.id,
      title: title,
      subtitle: subtitle,
      amount: 'Rp${tx.amount}',
      status: statusLabel,
      statusColor: statusColor,
      time: timeLabel,
      paymentMethod: tx.paymentMethod,
    );
  }
}

class _TransactionItem {
  const _TransactionItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.status,
    required this.statusColor,
    required this.time,
    required this.paymentMethod,
  });

  final String id;
  final String title;
  final String subtitle;
  final String amount;
  final String status;
  final Color statusColor;
  final String time;
  final String paymentMethod;
}

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({required this.tx});

  final _TransactionItem tx;

  @override
  Widget build(BuildContext context) {
    final status = tx.status.toLowerCase();
    final isPaid = status == 'lunas' || status == 'paid';
    final isRefund = status == 'batal' || status == 'refund';
    final iconColor = isPaid
        ? AppColors.green500
        : isRefund
            ? AppColors.red500
            : AppColors.orange500;
    return Padding(
      padding: const EdgeInsets.all(AppDimens.spacingMd),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPaid
                  ? Icons.check_circle_rounded
                  : isRefund
                      ? Icons.cancel_rounded
                      : Icons.more_horiz_rounded,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: AppDimens.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tx.id,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 12, color: Colors.white54),
                    const SizedBox(width: 4),
                    Text(
                      '${tx.time} • ${tx.paymentMethod}',
                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                tx.amount,
                style: const TextStyle(
                  color: AppColors.orange500,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              _StatusPill(label: tx.status, color: tx.statusColor),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spacingSm,
        vertical: AppDimens.spacingXs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, this.isActive = false});

  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spacingLg,
        vertical: AppDimens.spacingSm,
      ),
      decoration: BoxDecoration(
        color: isActive ? AppColors.orange500 : AppColors.grey700,
        borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.black : Colors.white,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
    );
  }
}

