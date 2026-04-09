import "package:flutter/material.dart";

/// Définit l'ambiance visuelle avec une image positionnée en haut et un fondu vers le blanc.
class WelcomeBackground extends StatelessWidget {
  const WelcomeBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        Positioned(
          top: -60,
          left: 0,
          right: 0,
          child: Image.asset(
            "assets/images/welcome.jpg",
            fit: BoxFit.cover,
            alignment: const Alignment(0, -1.0),
            cacheWidth: 1080,
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withValues(alpha: 0.0),
                  Colors.white.withValues(alpha: 0.0),
                  Colors.white.withValues(alpha: 1),
                  Colors.white,
                ],
                stops: const [0.0, 0.2, 0.6, 0.8],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
