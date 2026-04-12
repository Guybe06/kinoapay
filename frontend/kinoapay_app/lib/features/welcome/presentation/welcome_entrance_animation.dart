import "package:flutter/material.dart";

/// Définit toutes les animations d'entrée en cascade de la page Welcome.
/// Chaque animation est un intervalle sur un seul AnimationController de 1 100ms.
class WelcomeEntranceAnimation {
  final AnimationController controller;
  late final Animation<double> title;
  late final Animation<double> subtitle;
  late final Animation<double> images;
  late final Animation<double> imagesScale;
  late final Animation<double> button;
  late final Animation<double> link;

  /// @param controller  AnimationController principal (durée 1 100ms)
  WelcomeEntranceAnimation(this.controller) {
    title = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.00, 0.48, curve: Curves.easeOutCubic),
    );
    subtitle = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.12, 0.58, curve: Curves.easeOutCubic),
    );
    images = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.22, 0.72, curve: Curves.easeOut),
    );
    imagesScale = Tween<double>(begin: 0.86, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.22, 0.72, curve: Curves.easeOutBack),
      ),
    );
    button = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.44, 0.88, curve: Curves.easeOutQuart),
    );
    link = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.60, 1.00, curve: Curves.easeOut),
    );
  }
}
