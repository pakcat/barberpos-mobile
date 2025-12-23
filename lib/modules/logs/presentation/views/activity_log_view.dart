import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../core/values/app_strings.dart';

import '../../../../core/values/app_colors.dart';
import '../../../../core/values/app_dimens.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_side_drawer.dart';
import '../../../../core/services/activity_log_service.dart';
import '../controllers/logs_controller.dart';

class ActivityLogView extends GetView<LogsController> {
  const ActivityLogView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: AppStrings.activityLogTitle,
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
          Row(
            children: [
              _FilterChip(
                label: AppStrings.allCategories,
                active: controller.filter.value == AppStrings.allCategories,
                onTap: () => controller.setFilter(AppStrings.allCategories),
              ),
              const SizedBox(width: AppDimens.spacingSm),
              _FilterChip(
                label: 'info',
                active: controller.filter.value == 'info',
                onTap: () => controller.setFilter('info'),
              ),
              const SizedBox(width: AppDimens.spacingSm),
              _FilterChip(
                label: 'warning',
                active: controller.filter.value == 'warning',
                onTap: () => controller.setFilter('warning'),
              ),
              const SizedBox(width: AppDimens.spacingSm),
              _FilterChip(
                label: 'error',
                active: controller.filter.value == 'error',
                onTap: () => controller.setFilter('error'),
              ),
            ],
          ),
          const SizedBox(height: AppDimens.spacingLg),
          Expanded(
            child: Obx(() {
              final items = controller.items;
              if (items.isEmpty) {
                return const AppEmptyState(
                  title: AppStrings.noActivity,
                  message: AppStrings.noActivityMessage,
                );
              }
              return ListView.separated(
                itemCount: items.length,
                separatorBuilder: (context, _) => const SizedBox(height: AppDimens.spacingSm),
                itemBuilder: (context, index) {
                  final log = items[index];
                  final color = _colorFor(log.type);
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
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color: color.withAlpha((0.16 * 255).round()),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(_iconFor(log.type), color: color),
                        ),
                        const SizedBox(width: AppDimens.spacingMd),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    log.title,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium?.copyWith(color: Colors.white),
                                  ),
                                  Text(
                                    _formatTime(log.timestamp),
                                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppDimens.spacingXs),
                              Text(log.message, style: const TextStyle(color: Colors.white70)),
                              const SizedBox(height: AppDimens.spacingXs),
                              Text(
                                '${AppStrings.actor}: ${log.actor} | ${AppStrings.type}: ${log.type.name}',
                                style: const TextStyle(color: Colors.white54, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Color _colorFor(ActivityLogType type) {
    switch (type) {
      case ActivityLogType.warning:
        return AppColors.yellow500;
      case ActivityLogType.error:
        return AppColors.red500;
      case ActivityLogType.info:
        return AppColors.orange500;
    }
  }

  IconData _iconFor(ActivityLogType type) {
    switch (type) {
      case ActivityLogType.warning:
        return Icons.warning_amber_rounded;
      case ActivityLogType.error:
        return Icons.error_outline_rounded;
      case ActivityLogType.info:
        return Icons.info_outline_rounded;
    }
  }

  String _formatTime(DateTime time) {
    return DateFormat('dd/MM/yyyy HH:mm').format(time);
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.active, required this.onTap});

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spacingMd,
          vertical: AppDimens.spacingXs,
        ),
        decoration: BoxDecoration(
          color: active ? AppColors.orange500 : AppColors.grey800,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.grey700),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.black : Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
