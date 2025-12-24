import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/models/notification_message.dart';
import '../../../../core/utils/local_time.dart';
import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Notifikasi',
      backgroundColor: AppColors.grey900,
      appBarBackgroundColor: Colors.transparent,
      appBarForegroundColor: Colors.white,
      body: Obx(() {
        final items = controller.items;
        if (items.isEmpty) {
          return const Center(
            child: Text('Belum ada notifikasi', style: TextStyle(color: Colors.white70)),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.all(AppDimens.spacingLg),
          itemCount: items.length,
          separatorBuilder: (context, _) => const SizedBox(height: AppDimens.spacingSm),
          itemBuilder: (context, index) {
            final log = items[index];
            return _NotificationTile(
              title: log.title,
              message: log.message,
              timestamp: log.timestamp,
              type: log.type,
            );
          },
        );
      }),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
  });

  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;

  @override
  Widget build(BuildContext context) {
    final color = switch (type) {
      NotificationType.error => AppColors.red500,
      NotificationType.warning => AppColors.orange500,
      NotificationType.info => AppColors.blue500,
    };
    return Container(
      padding: const EdgeInsets.all(AppDimens.spacingMd),
      decoration: BoxDecoration(
        color: AppColors.grey800,
        borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
        border: Border.all(color: AppColors.grey700),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.notifications_active_rounded, color: color, size: 20),
          ),
          const SizedBox(width: AppDimens.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(message, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 4),
                Text(
                  _formatTimestamp(timestamp),
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime ts) {
    final t = asLocalTime(ts);
    return '${t.year}-${t.month.toString().padLeft(2, '0')}-${t.day.toString().padLeft(2, '0')} '
        '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }
}
