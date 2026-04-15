import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";

/// Barre de progression indéterminée affichée pendant la vérification réseau.
class SplashProgressBar extends StatelessWidget {
  const SplashProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: LinearProgressIndicator(
          backgroundColor: AppColors.stone900.withValues(alpha: 0.1),
          valueColor: AlwaysStoppedAnimation<Color>(
            AppColors.stone900.withValues(alpha: 0.4),
          ),
          minHeight: 2,
        ),
      ),
    );
  }
}

/// Message d'erreur réseau et bouton de relance affiché quand la connexion échoue.
class SplashOfflinePanel extends StatelessWidget {
  final VoidCallback onRetry;

  /// @param onRetry  Callback déclenché quand l'utilisateur tape "Réessayer"
  const SplashOfflinePanel({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 14, color: AppColors.stone700),
            const SizedBox(width: 8),
            Text(
              "Aucune connexion internet.",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.stone700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: onRetry,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.stone900,
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Text(
              "Réessayer",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textLight,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Message de confirmation affiché brièvement quand la connexion est rétablie automatiquement.
class SplashBackOnlinePanel extends StatelessWidget {
  const SplashBackOnlinePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.wifi_rounded, size: 14, color: AppColors.success),
        const SizedBox(width: 8),
        Text(
          "Connexion rétablie.",
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.stone700,
          ),
        ),
      ],
    );
  }
}
