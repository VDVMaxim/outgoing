import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class AppTheme {
  static ThemeData get dark => ThemeData.dark(useMaterial3: true).copyWith(
    scaffoldBackgroundColor: AppColors.darkBackground,
    canvasColor: AppColors.darkBackground,
    cardColor: AppColors.darkSurface,
    primaryColor: AppColors.primary,
    colorScheme: ColorScheme.dark(
      primary: AppColors.primary,
      surface: AppColors.darkSurface,
    ),
  );

  static ThemeData get light => ThemeData.light(useMaterial3: true).copyWith(
    scaffoldBackgroundColor: AppColors.lightBackground,
    canvasColor: AppColors.lightBackground,
    cardColor: AppColors.lightSurface,
    primaryColor: AppColors.primary,
    colorScheme: ColorScheme.light(
      primary: AppColors.primary,
      surface: AppColors.lightSurface,
    ),
  );

  static Color backgroundColor(Brightness brightness) =>
      brightness == Brightness.dark
      ? AppColors.darkBackground
      : AppColors.lightBackground;

  static Color surfaceColor(Brightness brightness) =>
      brightness == Brightness.dark
      ? AppColors.darkSurface
      : AppColors.lightSurface;
}
