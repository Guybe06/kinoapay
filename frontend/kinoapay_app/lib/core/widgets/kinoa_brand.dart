import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";

/// Définit les tailles standardisées pour le composant Brand.
enum BrandSize {
  xs(iconSize: 16, fontSize: 14),
  sm(iconSize: 20, fontSize: 18),
  md(iconSize: 28, fontSize: 24),
  lg(iconSize: 40, fontSize: 32),
  xl(iconSize: 56, fontSize: 44);

  final double iconSize;
  final double fontSize;

  const BrandSize({required this.iconSize, required this.fontSize});
}

/// Affiche l'identité visuelle combinée (Logo + Nom) de KinoaPay.
class KinoaBrand extends StatelessWidget {
  final BrandSize size;
  final Color? color;
  final Color? iconColor;
  final MainAxisAlignment alignment;

  const KinoaBrand({
    super.key,
    this.size = BrandSize.md,
    this.color,
    this.iconColor,
    this.alignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? KinoaColors.background;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: alignment,
      children: [
        Image.asset(
          "assets/images/logo.png",
          height: size.iconSize,
          color: iconColor,
        ),
        const SizedBox(width: 8),
        Text(
          "KinoaPay",
          style: GoogleFonts.plusJakartaSans(
            fontSize: size.fontSize,
            fontWeight: FontWeight.w500,
            color: effectiveColor,
            letterSpacing: -0.8,
          ),
        ),
      ],
    );
  }
}
