import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/widgets/brand_logo_row.dart";

/// En-tête standardisé des écrans d'authentification (logo centré, sans bouton retour).
class AuthScreenHeader extends StatelessWidget {
  const AuthScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Center(
        child: const BrandLogoRow(
          size: BrandSize.sm,
          color: AppColors.quinoaDark,
          iconColor: AppColors.quinoaGold,
        ),
      ),
    );
  }
}
