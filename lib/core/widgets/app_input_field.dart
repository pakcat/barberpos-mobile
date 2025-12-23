import 'package:flutter/material.dart';

import '../values/app_colors.dart';
import '../values/app_dimens.dart';

class AppInputField extends StatelessWidget {
  const AppInputField({
    super.key,
    required this.hint,
    this.prefix,
    this.suffix,
    this.controller,
    this.keyboardType,
    this.enabled = true,
    this.onChanged,
    this.maxLines = 1,
  });

  final String hint;
  final Widget? prefix;
  final Widget? suffix;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      onChanged: onChanged,
      maxLines: maxLines,
      style: const TextStyle(color: Color(0xFFF8F8F8)),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: prefix,
        suffixIcon: suffix,
        filled: true,
        fillColor: AppColors.grey800,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spacingMd,
          vertical: AppDimens.spacingSm,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
          borderSide: const BorderSide(color: AppColors.grey700),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
          borderSide: const BorderSide(color: AppColors.grey700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
          borderSide: const BorderSide(color: AppColors.orange500),
        ),
      ),
    );
  }
}
