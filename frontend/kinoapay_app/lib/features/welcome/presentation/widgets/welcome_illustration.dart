import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";

/// Illustration de l'écran d'accueil : trois cartes en V centré.
class WelcomeIllustration extends StatelessWidget {
  const WelcomeIllustration({super.key});

  static const double _cardW = 130.0;
  static const double _cardH = 176.0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 340,
        height: 280,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.translate(
              offset: const Offset(-90, -30),
              child: Transform.rotate(
                angle: -0.32,
                child: _buildCard("assets/images/welcome.jpg"),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, 48),
              child: _buildCard("assets/images/welcome-3.jpg"),
            ),
            Transform.translate(
              offset: const Offset(90, -30),
              child: Transform.rotate(
                angle: 0.32,
                child: _buildCard("assets/images/welcome-2.jpg"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String asset) {
    return Container(
      width: _cardW,
      height: _cardH,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: KinoaColors.quinoaGold.withValues(alpha: 0.25), width: 1),
        boxShadow: [
          BoxShadow(
            color: KinoaColors.quinoaGold.withValues(alpha: 0.10),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(asset, fit: BoxFit.cover),
      ),
    );
  }
}
