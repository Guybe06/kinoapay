import "package:flutter/material.dart";

/// Définit un arrière-plan en dégradé multi-tons inspiré du style minimaliste moderne.
class WelcomeBackground extends StatelessWidget {
  const WelcomeBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFE0C3FC), // Mauve doux
                  Color(0xFFFEE1C7), // Orange/Pêche
                  Color(0xFFE2F3F5), // Bleu/Cyan très clair
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ),
        // Overlay pour adoucir le contraste avec le texte
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 0.2),
                  Colors.transparent,
                  Colors.white.withValues(alpha: 0.4),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
