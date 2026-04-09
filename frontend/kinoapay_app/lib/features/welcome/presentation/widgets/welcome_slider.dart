import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/features/welcome/domain/welcome_slide.dart";

/// Gère l'affichage cyclique des diapositives via un parcours de tableau.
class WelcomeSlider extends StatelessWidget {
  final PageController controller;
  final List<WelcomeSlide> slides;
  final ValueChanged<int> onPageChanged;

  const WelcomeSlider({
    super.key,
    required this.controller,
    required this.slides,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240, // Plus haut pour l'icône imposante
      child: PageView(
        controller: controller,
        onPageChanged: onPageChanged,
        children: slides.map((slide) => Column(
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: KinoaColors.stone50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                slide.icon,
                color: KinoaColors.primary,
                size: 48, // Icône beaucoup plus grande
              ),
            ),
            const SizedBox(height: 32),
            Text(
              slide.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: KinoaColors.stone900,
                fontSize: 22, // Titre plus fort
                fontWeight: FontWeight.w800,
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                slide.desc,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: KinoaColors.stone500,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
            ),
          ],
        )).toList(),
      ),
    );
  }
}
