import 'package:flutter/material.dart';
import 'common/colors.dart';

ThemeData buildAppTheme() {
  return ThemeData(
    primarySwatch: AppColors.primarySwatch,
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      surface: AppColors.background,
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 35,
        fontWeight: FontWeight.bold,
        color: AppColors.textTitle,
        height: 1.1,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w500,
        color: AppColors.textTitle,
        height: 1.4,
      ),
      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textTitle,
      ),
      bodyLarge: TextStyle(
        fontSize: 22,
        color: AppColors.textBody,
        height: 1.3,
      ),
      bodyMedium: TextStyle(
        fontSize: 18,
        color: AppColors.textLight,
      ),
      labelLarge: TextStyle(
        fontSize: 20,
        color: AppColors.textBody,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.transparent,
        shadowColor: AppColors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
    ),
  );
}
