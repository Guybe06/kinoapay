import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:google_fonts/google_fonts.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";

/// Thèmes Material 3 (clair et sombre) basés sur [AppColors] et [ColorScheme].
class AppTheme {
  static ThemeData light() {
    return _build(
      brightness: Brightness.light,
      colorScheme: _lightColorScheme(),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }

  static ThemeData dark() {
    return _build(
      brightness: Brightness.dark,
      colorScheme: _darkColorScheme(),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    );
  }

  static ThemeData _build({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required SystemUiOverlayStyle systemOverlayStyle,
  }) {
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(
      brightness == Brightness.light
          ? ThemeData.light().textTheme
          : ThemeData.dark().textTheme,
    ).apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,
      splashFactory: NoSplash.splashFactory,
      hoverColor: AppColors.transparent,
      highlightColor: AppColors.transparent,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        systemOverlayStyle: systemOverlayStyle,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          splashFactory: NoSplash.splashFactory,
          overlayColor: AppColors.transparent,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
      ),
    );
  }

  static ColorScheme _lightColorScheme() {
    return ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.textLight,
      secondary: AppColors.accent,
      onSecondary: AppColors.stone900,
      surface: AppColors.backgroundLight,
      onSurface: AppColors.textMain,
      surfaceContainerHighest: AppColors.stone100,
      onSurfaceVariant: AppColors.textMuted,
      outline: AppColors.border,
      outlineVariant: AppColors.stone200,
      error: AppColors.error,
      onError: AppColors.textLight,
      tertiary: AppColors.success,
      onTertiary: AppColors.textLight,
    );
  }

  static ColorScheme _darkColorScheme() {
    return ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: AppColors.textLight,
      secondary: AppColors.accent,
      onSecondary: AppColors.stone900,
      surface: AppColors.background,
      onSurface: AppColors.textLight,
      surfaceContainerHighest: AppColors.stone800,
      onSurfaceVariant: AppColors.stone400,
      outline: AppColors.borderDark,
      outlineVariant: AppColors.stone700,
      error: AppColors.error,
      onError: AppColors.textLight,
      tertiary: AppColors.success,
      onTertiary: AppColors.textLight,
    );
  }
}

/// Accès raccourci au [ColorScheme] courant via [BuildContext].
extension AppThemeContext on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
