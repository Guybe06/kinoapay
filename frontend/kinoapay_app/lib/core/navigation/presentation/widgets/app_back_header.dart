import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";

/// En-tête partagée : bouton retour à gauche, titre centré, cloche à droite.
///
/// [backLabel] — affiché à côté de la flèche pour indiquer la zone de retour.
/// [title] — titre de la page courante, affiché au centre.
/// [trailing] — remplace la cloche par un widget personnalisé si fourni.
/// Utilisée sur toutes les pages secondaires (Plus, Envoi, Historique, etc.).
class AppBackHeader extends StatelessWidget {
  final VoidCallback onBack;
  final String? backLabel;
  final String? title;
  final int unreadNotifications;
  final Widget? trailing;

  const AppBackHeader({
    super.key,
    required this.onBack,
    this.backLabel,
    this.title,
    this.unreadNotifications = 0,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;

    return Material(
      color: AppColors.quinoaCream,
      elevation: 0,
      shadowColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, topInset + 10, 20, 10),
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (title != null)
              Text(
                title!,
                style: const TextStyle(
                  color: AppColors.quinoaDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
            GestureDetector(
              onTap: onBack,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.quinoaDark.withValues(alpha: 0.06),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      SolarIconsOutline.altArrowLeft,
                      size: 18,
                      color: AppColors.quinoaDark,
                    ),
                  ),
                  if (backLabel != null) ...[
                    const SizedBox(width: 8),
                    Text(
                      backLabel!,
                      style: TextStyle(
                        color: AppColors.quinoaDark.withValues(alpha: 0.45),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            trailing ?? GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
              child: const Icon(
                SolarIconsOutline.bell,
                size: 26,
                color: AppColors.quinoaGold,
              ),
            ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
