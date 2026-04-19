import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/widgets/brand_logo_row.dart";

/// En-tête standardisé des écrans d'authentification (flèche retour + logo centré).
/// La flèche utilise [Navigator.maybePop] : elle pop l'écran courant si la pile le permet,
/// sinon ne fait rien (pas de navigation fantôme vers welcome).
class AuthScreenHeader extends StatelessWidget {
  const AuthScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(SolarIconsOutline.altArrowLeft, color: AppColors.quinoaDark),
            onPressed: () => Navigator.maybePop(context),
          ),
          const Spacer(),
          const BrandLogoRow(size: BrandSize.sm, color: AppColors.quinoaDark, iconColor: AppColors.quinoaGold),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
