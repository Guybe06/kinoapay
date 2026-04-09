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
      height: 220,
      child: PageView(
        controller: controller,
        onPageChanged: onPageChanged,
        children: slides.map((slide) => Column(
          children: [
            Icon(
              slide.icon,
              color: KinoaColors.primary,
              size: 40,
            ),
            const SizedBox(height: 16),
            Text(
              slide.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: KinoaColors.stone900,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              slide.desc,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: KinoaColors.stone500,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        )).toList(),
      ),
    );
  }
}
