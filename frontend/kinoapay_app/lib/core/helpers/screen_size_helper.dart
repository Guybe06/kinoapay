import "package:flutter/material.dart";

/// Catégories de tailles d'écran pour adaptation responsive.
/// Basé sur la hauteur logique (dp) qui est le vrai contraint sur mobile.
enum ScreenSizeCategory {
  /// Très petit : iPhone SE, 6/7/8 (≤ 700dp)
  compact(heightThreshold: 720),

  /// Petit : iPhone 12 mini, X/XS/11 Pro (720-812dp)
  small(heightThreshold: 850),

  /// Standard : iPhone 12/13/14/15, XR/11, Pixel 6/7/8 (850-920dp)
  medium(heightThreshold: 920),

  /// Grand : Pixel 9, iPhone Pro Max (> 920dp)
  large(heightThreshold: double.infinity);

  final double heightThreshold;
  const ScreenSizeCategory({required this.heightThreshold});
}

/// Helper pour détecter la catégorie de taille d'écran.
/// Usage : final size = ScreenSizeHelper.of(context);
abstract final class ScreenSizeHelper {
  /// Retourne la catégorie basée sur la hauteur disponible (hauteur moins padding top/bottom).
  static ScreenSizeCategory of(BuildContext context) {
    final view = View.of(context);
    final padding = MediaQueryData.fromView(view).padding;
    final height =
        view.physicalSize.height / view.devicePixelRatio -
        padding.top -
        padding.bottom;

    if (height <= ScreenSizeCategory.compact.heightThreshold) {
      return ScreenSizeCategory.compact;
    } else if (height <= ScreenSizeCategory.small.heightThreshold) {
      return ScreenSizeCategory.small;
    } else if (height <= ScreenSizeCategory.medium.heightThreshold) {
      return ScreenSizeCategory.medium;
    }
    return ScreenSizeCategory.large;
  }

  /// Retourne true si l'écran est compact (≤ 700dp de hauteur utile).
  static bool isCompact(BuildContext context) =>
      of(context) == ScreenSizeCategory.compact;

  /// Retourne true si l'écran est petit ou plus (≤ 800dp).
  static bool isSmallOrLess(BuildContext context) {
    final category = of(context);
    return category == ScreenSizeCategory.compact ||
        category == ScreenSizeCategory.small;
  }

  /// Retourne un spacing adaptatif basé sur la catégorie.
  /// [normal] valeur par défaut, [compact] valeur pour petits écrans.
  static double adaptiveSpacing(
    BuildContext context, {
    required double normal,
    required double compact,
  }) {
    return isCompact(context) ? compact : normal;
  }

  /// Retourne une valeur parmi 4 selon la catégorie d'écran.
  /// Permet d'affiner par : compact → small → medium → large
  static double adaptiveValue(
    BuildContext context, {
    required double compact,
    required double small,
    required double medium,
    required double large,
  }) {
    final category = of(context);
    switch (category) {
      case ScreenSizeCategory.compact:
        return compact;
      case ScreenSizeCategory.small:
        return small;
      case ScreenSizeCategory.medium:
        return medium;
      case ScreenSizeCategory.large:
        return large;
    }
  }
}
