import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/features/welcome/domain/welcome_slide.dart";

/// Affiche les points indicateurs synchronisés avec le tableau de diapositives.
class WelcomeDots extends StatelessWidget {
  final List<WelcomeSlide> slides;
  final int activeIndex;

  const WelcomeDots({
    super.key,
    required this.slides,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: slides.asMap().entries.map((entry) {
        bool isActive = entry.key == activeIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 6,
          width: isActive ? 24 : 6,
          decoration: BoxDecoration(
            color: isActive
                ? KinoaColors.primary
                : KinoaColors.background.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }).toList(),
    );
  }
}
