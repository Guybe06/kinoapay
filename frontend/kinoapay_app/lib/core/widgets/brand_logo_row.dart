import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";
import "package:kinoapay_app/core/constants/asset_paths.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_strings.dart";

/// Tailles standardisées du composant [BrandLogoRow].
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

/// Logo et nom de marque ; [heroTag] optionnel pour une transition Hero (ex. depuis le splash).
class BrandLogoRow extends StatelessWidget {
  final BrandSize size;
  final Color? color;
  final Color? iconColor;
  final MainAxisAlignment alignment;
  final String? heroTag;

  const BrandLogoRow({
    super.key,
    this.size = BrandSize.md,
    this.color,
    this.iconColor,
    this.alignment = MainAxisAlignment.center,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final Widget brand = _buildBrand();
    if (heroTag != null) {
      return Hero(
        tag: heroTag!,
        flightShuttleBuilder: (_, animation, direction, fromCtx, toCtx) {
          return Material(
            type: MaterialType.transparency,
            child: _buildBrand(),
          );
        },
        child: brand,
      );
    }
    return brand;
  }

  Widget _buildBrand() {
    final effectiveColor = color ?? AppColors.textLight;

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: alignment,
      children: [
        Image.asset(
          AssetPaths.brandLogo,
          height: size.iconSize,
          color: iconColor,
        ),
        const SizedBox(width: 8),
        Text(
          AppStrings.appName,
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
