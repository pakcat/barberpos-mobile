import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_dimens.dart';
import 'app_typography.dart';

class AppThemes {
  const AppThemes._();

  static ThemeData get light => ThemeData(
    brightness: Brightness.dark,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.grey100,
      selectionColor: Color(0x33F8F8F8),
      selectionHandleColor: AppColors.grey100,
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      primary: AppColors.primary,
      secondary: AppColors.accent,
      surface: AppColors.grey900,
      onSurface: AppColors.grey100,
      error: AppColors.error,
    ),
    scaffoldBackgroundColor: AppColors.grey900,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: AppColors.grey100,
    ),
    textTheme: _textTheme,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.grey800,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
        borderSide: const BorderSide(color: AppColors.grey700),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
        borderSide: const BorderSide(color: AppColors.grey700),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimens.cornerRadius),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.2),
      ),
      labelStyle: const TextStyle(color: AppColors.grey100),
      floatingLabelStyle: const TextStyle(color: AppColors.grey100),
      hintStyle: TextStyle(color: AppColors.grey100.withValues(alpha: 0.72)),
      suffixIconColor: AppColors.grey100,
      prefixIconColor: AppColors.grey100,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(88, AppDimens.buttonHeight),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.cornerRadius)),
      ),
    ),
  );

  static TextTheme get _textTheme {
    // START: OFFLINE-SAFE FONT LOADING
    // Using standard TextTheme to prevent crash if google_fonts fails to download.
    // Ensure 'Montserrat' font files are added to assets in pubspec.yaml for consistent look.
    const base = TextTheme(
      headlineSmall: TextStyle(fontFamily: 'Montserrat'),
      titleMedium: TextStyle(fontFamily: 'Montserrat'),
      bodyLarge: TextStyle(fontFamily: 'Montserrat'),
      bodyMedium: TextStyle(fontFamily: 'Montserrat'),
      bodySmall: TextStyle(fontFamily: 'Montserrat'),
    );
    // END: OFFLINE-SAFE FONT LOADING

    return base.copyWith(
      headlineSmall: base.headlineSmall?.copyWith(
        fontWeight: AppTypography.fontWeightSemiBold,
        color: AppColors.grey100,
      ),
      titleMedium: base.titleMedium?.copyWith(
        fontWeight: AppTypography.fontWeightMedium,
        color: AppColors.grey100,
      ),
      bodyLarge: base.bodyLarge?.copyWith(color: AppColors.grey100),
      bodyMedium: base.bodyMedium?.copyWith(
        fontWeight: AppTypography.fontWeightRegular,
        color: AppColors.grey200,
      ),
      bodySmall: base.bodySmall?.copyWith(
        fontWeight: AppTypography.fontWeightLight,
        color: AppColors.grey200,
      ),
    );
  }
}
