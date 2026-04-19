import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/core/widgets/brand_logo_row.dart";

/// En-tête standardisé des écrans d'authentification (flèche retour + logo centré).
/// Si un écran est empilé au-dessus (ex. welcome → signin), pop vers lui.
/// Si l'écran est root (ex. utilisateur récurrent directement sur signin),
/// navigue vers welcome via pushReplacement pour ne pas créer de pile infinie.
class AuthScreenHeader extends StatelessWidget {
  const AuthScreenHeader({super.key});

  void _handleBack(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.welcome);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(SolarIconsOutline.altArrowLeft, color: AppColors.quinoaDark),
            onPressed: () => _handleBack(context),
          ),
          const Spacer(),
          const BrandLogoRow(size: BrandSize.sm, color: AppColors.quinoaDark, iconColor: AppColors.quinoaGold),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
