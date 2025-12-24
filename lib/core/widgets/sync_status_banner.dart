import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/sync_queue_service.dart';
import '../values/app_colors.dart';
import '../values/app_dimens.dart';
import '../../routes/app_routes.dart';

class SyncStatusBanner extends StatelessWidget {
  const SyncStatusBanner({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<SyncQueueService>()) return const SizedBox.shrink();
    final service = Get.find<SyncQueueService>();

    return Obx(() {
      final pendingPrimary = service.pendingPrimaryCount.value;
      final pendingLogs = service.pendingLogsCount.value;
      final pendingTotal = pendingPrimary + pendingLogs;
      final failedTotal = service.failedCount.value;
      if (pendingTotal <= 0) return const SizedBox.shrink();

      final color = failedTotal > 0 ? AppColors.red500 : AppColors.orange500;

      var text = '';
      if (pendingPrimary > 0 && pendingLogs > 0) {
        text = 'Ada $pendingPrimary data pending sync + $pendingLogs log aktivitas';
      } else if (pendingPrimary > 0) {
        text = 'Ada $pendingPrimary data pending sync';
      } else {
        text = 'Ada $pendingLogs log aktivitas pending sync';
      }
      if (failedTotal > 0) text = '$text ($failedTotal gagal)';

      return Padding(
        padding: const EdgeInsets.only(bottom: AppDimens.spacingLg),
        child: InkWell(
          onTap: () => Get.toNamed(Routes.sync),
          borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppDimens.spacingMd),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
              border: Border.all(color: color.withValues(alpha: 0.35)),
            ),
            child: Row(
              children: [
                Icon(Icons.cloud_sync_rounded, color: color),
                const SizedBox(width: AppDimens.spacingSm),
                Expanded(
                  child: Text(
                    text,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: color),
              ],
            ),
          ),
        ),
      );
    });
  }
}
