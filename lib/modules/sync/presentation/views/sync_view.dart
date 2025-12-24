import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/utils/local_time.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_side_drawer.dart';
import '../controllers/sync_controller.dart';

class SyncView extends GetView<SyncController> {
  const SyncView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Sinkronisasi',
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
        Obx(
          () => IconButton(
            tooltip: 'Sync sekarang',
            onPressed: controller.syncing.value ? null : controller.syncNow,
            icon: controller.syncing.value
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.sync_rounded),
          ),
        ),
      ],
      body: RefreshIndicator(
        color: AppColors.orange500,
        onRefresh: controller.refresh,
        child: Obx(() {
          if (controller.loading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final mainItems = controller.mainItems;
          final logItems = controller.logItems;
          if (mainItems.isEmpty && logItems.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(AppDimens.spacingXl),
                child: Text(
                  'Semua data sudah tersinkron.',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(AppDimens.spacingLg),
            children: [
              _SummaryCard(
                mainPending: controller.totalMainPending,
                mainFailed: controller.totalMainFailed,
                logPending: controller.totalLogPending,
                logFailed: controller.totalLogFailed,
              ),
              const SizedBox(height: AppDimens.spacingLg),
              const Text(
                'Queue utama',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppDimens.spacingSm),
              if (mainItems.isEmpty)
                const AppCard(
                  backgroundColor: AppColors.grey800,
                  borderColor: AppColors.grey700,
                  padding: EdgeInsets.all(AppDimens.spacingLg),
                  child: Text(
                    'Tidak ada data utama yang menunggu sync.',
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              else
                ...mainItems.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: AppDimens.spacingMd),
                    child: _QueueItemTile(item: item),
                  ),
                ),
              const SizedBox(height: AppDimens.spacingLg),
              _LogSection(items: logItems),
            ],
          );
        }),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.mainPending,
    required this.mainFailed,
    required this.logPending,
    required this.logFailed,
  });

  final int mainPending;
  final int mainFailed;
  final int logPending;
  final int logFailed;

  @override
  Widget build(BuildContext context) {
    final totalPending = mainPending + logPending;
    final totalFailed = mainFailed + logFailed;

    return AppCard(
      backgroundColor: AppColors.grey800,
      borderColor: AppColors.grey700,
      padding: const EdgeInsets.all(AppDimens.spacingLg),
      child: Row(
        children: [
          const Icon(Icons.cloud_sync_rounded, color: AppColors.orange500),
          const SizedBox(width: AppDimens.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Queue Sinkronisasi',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  'Total pending: $totalPending • Gagal: $totalFailed',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  'Utama: $mainPending • Log aktivitas: $logPending',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LogSection extends StatelessWidget {
  const _LogSection({required this.items});

  final List<SyncQueueItem> items;

  @override
  Widget build(BuildContext context) {
    final failed = items.where((e) => e.failed).length;
    final title = failed > 0
        ? 'Log aktivitas (${items.length} pending, $failed gagal)'
        : 'Log aktivitas (${items.length} pending)';

    return AppCard(
      backgroundColor: AppColors.grey800,
      borderColor: AppColors.grey700,
      padding: EdgeInsets.zero,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: false,
          collapsedIconColor: Colors.white70,
          iconColor: Colors.white70,
          title: Text(
            title,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          subtitle: const Text(
            'Disembunyikan untuk menghindari salah paham; buka jika perlu.',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
          children: [
            if (items.isEmpty)
              const Padding(
                padding: EdgeInsets.all(AppDimens.spacingLg),
                child: Text('Tidak ada log yang menunggu sync.', style: TextStyle(color: Colors.white70)),
              )
            else
              ...items.map(
                (item) => Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimens.spacingLg,
                    0,
                    AppDimens.spacingLg,
                    AppDimens.spacingMd,
                  ),
                  child: _QueueItemTile(item: item),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _QueueItemTile extends StatelessWidget {
  const _QueueItemTile({required this.item});

  final SyncQueueItem item;

  String _formatDate(DateTime dt) {
    dt = asLocalTime(dt);
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final c = Get.find<SyncController>();
    final failed = item.failed;
    final badgeColor = failed ? AppColors.red500 : AppColors.orange500;
    final badgeText = failed ? 'Gagal' : 'Pending';

    return AppCard(
      backgroundColor: AppColors.grey800,
      borderColor: AppColors.grey700,
      padding: const EdgeInsets.all(AppDimens.spacingMd),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: badgeColor.withValues(alpha: 0.35)),
            ),
            child: Text(
              badgeText,
              style: TextStyle(color: badgeColor, fontWeight: FontWeight.w700, fontSize: 12),
            ),
          ),
          const SizedBox(width: AppDimens.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                ),
                if ((item.subtitle ?? '').trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(item.subtitle!, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                ],
                const SizedBox(height: 6),
                Text(
                  'Dibuat: ${_formatDate(item.createdAt)} • Percobaan: ${item.attempts}',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
                if (item.nextAttemptAt != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Coba lagi: ${_formatDate(item.nextAttemptAt!)}',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
                if ((item.lastError ?? '').trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    item.lastError!,
                    style: const TextStyle(color: AppColors.red500, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppDimens.spacingMd),
          Column(
            children: [
              InkWell(
                onTap: () => c.retry(item),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.orange500.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.refresh_rounded, size: 18, color: AppColors.orange500),
                ),
              ),
              const SizedBox(height: AppDimens.spacingSm),
              InkWell(
                onTap: () => c.remove(item),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.red500.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.delete_rounded, size: 18, color: AppColors.red500),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
