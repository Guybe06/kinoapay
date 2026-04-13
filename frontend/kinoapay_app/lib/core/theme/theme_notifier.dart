import "package:flutter/material.dart";

/// Gère l'état du mode de thème actif (clair ou sombre). Clair par défaut.
class ThemeNotifier extends ValueNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light);

  void setDark() => value = ThemeMode.dark;
  void setLight() => value = ThemeMode.light;
  void toggle() => value = value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

  bool get isDark => value == ThemeMode.dark;
}
