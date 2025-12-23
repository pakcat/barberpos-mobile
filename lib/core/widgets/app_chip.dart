import 'package:flutter/material.dart';

import '../values/app_colors.dart';
import '../values/app_dimens.dart';

class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.icon,
    this.active = false,
    this.onTap,
  });

  final String label;
  final IconData? icon;
  final bool active;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.orange500 : AppColors.grey800;
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 16, color: active ? Colors.black : Colors.white70),
          const SizedBox(width: AppDimens.spacingXs),
        ],
        Text(
          label,
          style: TextStyle(
            color: active ? Colors.black : Colors.white,
            fontWeight: active ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ],
    );

    final chip = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.spacingMd,
        vertical: AppDimens.spacingSm,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
        border: Border.all(
          color: active ? AppColors.orange500 : AppColors.grey700,
        ),
      ),
      child: content,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
        child: chip,
      );
    }
    return chip;
  }
}
