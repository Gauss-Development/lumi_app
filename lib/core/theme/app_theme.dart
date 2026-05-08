import 'package:flutter/material.dart';

import 'package:lumi/core/theme/app_colors.dart';
import 'package:lumi/core/theme/app_text_styles.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
<<<<<<< HEAD
    final colorScheme = ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: AppColors.signatureCoral,
      surface: AppColors.surface,
      primary: AppColors.signatureCoral,
      secondary: AppColors.signatureGold,
=======
    const ColorScheme colorScheme = ColorScheme.dark(
      primary: AppColors.coral,
      secondary: AppColors.softLavender,
      surface: AppColors.card,
      error: AppColors.danger,
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
<<<<<<< HEAD
      scaffoldBackgroundColor: AppColors.midnight,
      textTheme: AppTextStyles.textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
=======
      scaffoldBackgroundColor: AppColors.deepNight,
      fontFamily: AppTextStyles.fontFamily,
      textTheme: AppTextStyles.textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        centerTitle: false,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
<<<<<<< HEAD
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceStrong,
        contentTextStyle: AppTextStyles.bodyMedium,
=======
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        showDragHandle: false,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.dusk,
        contentTextStyle: AppTextStyles.body,
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceStrong,
        contentPadding: const EdgeInsets.symmetric(
<<<<<<< HEAD
          horizontal: 18,
          vertical: 18,
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textMuted,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      dividerColor: AppColors.outline,
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
=======
          horizontal: 20,
          vertical: 18,
        ),
        hintStyle: AppTextStyles.body.copyWith(color: AppColors.textMuted),
        labelStyle: AppTextStyles.body.copyWith(color: AppColors.textMuted),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.softLavender),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: const BorderSide(color: AppColors.cardBorder),
        ),
      ),
      dividerColor: AppColors.outline,
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
      popupMenuTheme: PopupMenuThemeData(
        color: AppColors.dusk,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
>>>>>>> a650b6c24ad062b9f72a1933283e93767f3a358e
    );
  }
}
