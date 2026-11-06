import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class AppTheme {
  static const Color primaryColor = AppColors.primary;
  static const double cornerRadius = 16;
  static const double buttonRadius = 12;

  static final ButtonStyle _noPressEffect = ButtonStyle(
    splashFactory: NoSplash.splashFactory,
    overlayColor: WidgetStateProperty.all(AppColors.transparent),
  );

  static final ButtonStyle _buttonStyle = _noPressEffect.copyWith(
    minimumSize: WidgetStateProperty.all(const Size(0, 48)),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(buttonRadius)),
    ),
    textStyle: WidgetStateProperty.all(
      const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
    ),
  );

  // getter, not a field, so hot reload picks up theme changes
  static ThemeData get lightTheme => ThemeData(
    // fromSeed dulls the accent a bit, so set it explicitly
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: AppColors.primary,
      onPrimary: AppColors.white,
      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: AppColors.primary,
      secondaryContainer: AppColors.primaryLight,
      onSecondaryContainer: AppColors.primary,
      surface: AppColors.surface,
    ),
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,

    splashFactory: NoSplash.splashFactory,
    splashColor: AppColors.transparent,
    highlightColor: AppColors.transparent,

    appBarTheme: const AppBarTheme(
      centerTitle: true,
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textDark,
      scrolledUnderElevation: 0,
      surfaceTintColor: AppColors.transparent,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
    ),

    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      surfaceTintColor: AppColors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cornerRadius),
        side: const BorderSide(color: AppColors.border),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.primaryLight,
      side: const BorderSide(color: AppColors.border),
      shape: const StadiumBorder(),
    ),

    dividerTheme: const DividerThemeData(color: AppColors.border),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: AppColors.transparent,
      indicatorColor: AppColors.primaryLight,
      overlayColor: WidgetStateProperty.all(AppColors.transparent),
    ),

    filledButtonTheme: FilledButtonThemeData(style: _buttonStyle),
    outlinedButtonTheme: OutlinedButtonThemeData(style: _buttonStyle),
    textButtonTheme: TextButtonThemeData(style: _noPressEffect),
    elevatedButtonTheme: ElevatedButtonThemeData(style: _buttonStyle),
    iconButtonTheme: IconButtonThemeData(style: _noPressEffect),
    segmentedButtonTheme: SegmentedButtonThemeData(style: _noPressEffect),
  );
}
