import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/core/constants/kinoa_strings.dart";

/// Affiche une mention rassurante concernant la sécurité et la conformité.
class WelcomeTrustLabel extends StatelessWidget {
  const WelcomeTrustLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.shield_outlined,
          size: 14,
          color: KinoaColors.success,
        ),
        const SizedBox(width: 6),
        Text(
          KinoaStrings.welcomeTrustLabel,
          style: TextStyle(
            fontSize: 11,
            color: KinoaColors.background.withValues(alpha: 0.4),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
