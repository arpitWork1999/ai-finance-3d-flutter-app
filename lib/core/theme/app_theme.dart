import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// One place for the look of the whole app.
/// Screens only use the default widgets; this theme styles them.
class AppTheme {
  static const Color primaryColor = AppColors.primary;
  static const double cornerRadius = 16;
  static const double buttonRadius = 12;

  /// No press effect: no ripple and no grey highlight.
  static final ButtonStyle _noPressEffect = ButtonStyle(
    splashFactory: NoSplash.splashFactory,
    overlayColor: WidgetStateProperty.all(AppColors.transparent),
  );

  /// Buttons: no press effect, rounded corners, comfortable height.
  static final ButtonStyle _buttonStyle = _noPressEffect.copyWith(
    minimumSize: WidgetStateProperty.all(const Size(0, 48)),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(buttonRadius)),
    ),
    textStyle: WidgetStateProperty.all(
      const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
    ),
  );

  /// A getter (not a field), so hot reload picks up theme changes.
  static ThemeData get lightTheme => ThemeData(
    // fromSeed makes the color a bit dull, so we set the exact accent
    // color for buttons, icons and selected items.
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

    // No ripple or highlight when tapping cards, chips and list items.
    splashFactory: NoSplash.splashFactory,
    splashColor: AppColors.transparent,
    highlightColor: AppColors.transparent,

    // App bar: same color as the page, bold title, no change on scroll.
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

    // Cards: flat white with a thin border instead of a shadow.
    cardTheme: CardThemeData(
      color: AppColors.surface,
      elevation: 0,
      surfaceTintColor: AppColors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cornerRadius),
        side: const BorderSide(color: AppColors.border),
      ),
    ),

    // Chips: white pills with a thin border.
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surface,
      selectedColor: AppColors.primaryLight,
      side: const BorderSide(color: AppColors.border),
      shape: const StadiumBorder(),
    ),

    dividerTheme: const DividerThemeData(color: AppColors.border),

    // Bottom bar: white, with a light highlight on the selected tab.
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: AppColors.transparent,
      indicatorColor: AppColors.primaryLight,
      overlayColor: WidgetStateProperty.all(AppColors.transparent),
    ),

    // Buttons
    filledButtonTheme: FilledButtonThemeData(style: _buttonStyle),
    outlinedButtonTheme: OutlinedButtonThemeData(style: _buttonStyle),
    textButtonTheme: TextButtonThemeData(style: _noPressEffect),
    elevatedButtonTheme: ElevatedButtonThemeData(style: _buttonStyle),
    iconButtonTheme: IconButtonThemeData(style: _noPressEffect),
    segmentedButtonTheme: SegmentedButtonThemeData(style: _noPressEffect),
  );
}
