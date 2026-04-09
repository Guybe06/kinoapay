import "package:flutter/material.dart";

/// Représente les métadonnées d'une diapositive de l'écran d'introduction.
class WelcomeSlide {
  final IconData icon;
  final String title;
  final String desc;

  const WelcomeSlide({
    required this.icon,
    required this.title,
    required this.desc,
  });
}
