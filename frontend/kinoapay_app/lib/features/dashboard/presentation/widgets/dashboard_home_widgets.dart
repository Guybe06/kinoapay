import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";

/// Halos décoratifs derrière le contenu scrollable du tableau de bord.
class DashboardAmbientBackground extends StatelessWidget {
  const DashboardAmbientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 50,
          right: -80,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accent.withValues(alpha: 0.25),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 200,
          left: -100,
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accent.withValues(alpha: 0.15),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// En-tête texte (prénom utilisateur).
class DashboardGreetingSection extends StatelessWidget {
  final String firstName;
  const DashboardGreetingSection({super.key, required this.firstName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bienvenue,",
            style: TextStyle(
              color: AppColors.quinoaWarmGray.withValues(alpha: 0.75),
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            firstName.isNotEmpty ? firstName : "—",
            style: const TextStyle(
              color: AppColors.quinoaDark,
              fontSize: 32,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

/// Boutons rapides envoyer / demander.
class DashboardActionButtons extends StatelessWidget {
  final VoidCallback onSend;
  final VoidCallback onRequest;
  const DashboardActionButtons({
    super.key,
    required this.onSend,
    required this.onRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: DashboardActionButton(
              label: "ENVOYER",
              icon: SolarIconsOutline.arrowRightUp,
              onTap: onSend,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: DashboardActionButton(
              label: "DEMANDER",
              icon: SolarIconsOutline.cardReceive,
              onTap: onRequest,
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const DashboardActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: AppColors.quinoaDark.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: AppColors.quinoaDark.withValues(alpha: 0.07),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: AppColors.quinoaDark),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.quinoaDark,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Lien texte vers l’historique complet.
class DashboardVoirToutLink extends StatelessWidget {
  final VoidCallback onTap;
  const DashboardVoirToutLink({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.quinoaDark.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: AppColors.quinoaDark.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Voir tout",
              style: TextStyle(
                color: AppColors.quinoaWarmGray.withValues(alpha: 0.80),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 3),
            Icon(
              SolarIconsOutline.altArrowRight,
              size: 11,
              color: AppColors.quinoaWarmGray.withValues(alpha: 0.55),
            ),
          ],
        ),
      ),
    );
  }
}
