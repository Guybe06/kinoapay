import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:google_fonts/google_fonts.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";

/// Thèmes Material clair et sombre ; les couleurs passent par [KinoaColors], sans hex en dur.
class KinoaTheme {
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
      hoverColor: KinoaColors.transparent,
      highlightColor: KinoaColors.transparent,
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
          overlayColor: KinoaColors.transparent,
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
      primary: KinoaColors.primary,
      onPrimary: KinoaColors.textLight,
      secondary: KinoaColors.accent,
      onSecondary: KinoaColors.stone900,
      surface: KinoaColors.backgroundLight,
      onSurface: KinoaColors.textMain,
      surfaceContainerHighest: KinoaColors.stone100,
      onSurfaceVariant: KinoaColors.textMuted,
      outline: KinoaColors.border,
      outlineVariant: KinoaColors.stone200,
      error: KinoaColors.error,
      onError: KinoaColors.textLight,
      tertiary: KinoaColors.success,
      onTertiary: KinoaColors.textLight,
    );
  }

  static ColorScheme _darkColorScheme() {
    return ColorScheme(
      brightness: Brightness.dark,
      primary: KinoaColors.primary,
      onPrimary: KinoaColors.textLight,
      secondary: KinoaColors.accent,
      onSecondary: KinoaColors.stone900,
      surface: KinoaColors.background,
      onSurface: KinoaColors.textLight,
      surfaceContainerHighest: KinoaColors.stone800,
      onSurfaceVariant: KinoaColors.stone400,
      outline: KinoaColors.borderDark,
      outlineVariant: KinoaColors.stone700,
      error: KinoaColors.error,
      onError: KinoaColors.textLight,
      tertiary: KinoaColors.success,
      onTertiary: KinoaColors.textLight,
    );
  }
}

/// Extension sur [BuildContext] : couleurs sémantiques du thème actif (`context.colors.surface`, `context.colors.onSurface`, etc.).
extension KinoaThemeContext on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}
