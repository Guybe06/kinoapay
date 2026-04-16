import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/dashboard_strings.dart";

/// Bottom sheet « En savoir plus » : texte marketing structuré.
class DashboardPromoDetailSheet extends StatelessWidget {
  const DashboardPromoDetailSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.quinoaDark,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -100,
                right: -50,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.accent.withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                      children: [
                        const Text(
                          DashboardStrings.promoTitle,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.0,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const DashboardPromoInfoSection(
                          icon: SolarIconsOutline.link,
                          title: DashboardStrings.promoLink,
                          description: DashboardStrings.promoLinkDesc,
                        ),
                        const SizedBox(height: 32),
                        const DashboardPromoInfoSection(
                          icon: SolarIconsOutline.userId,
                          title: DashboardStrings.promoIdentity,
                          description: DashboardStrings.promoIdentityDesc,
                        ),
                        const SizedBox(height: 32),
                        const DashboardPromoInfoSection(
                          icon: SolarIconsOutline.safeCircle,
                          title: DashboardStrings.promoProof,
                          description: DashboardStrings.promoProofDesc,
                        ),
                        const SizedBox(height: 32),
                        const DashboardPromoInfoSection(
                          icon: SolarIconsOutline.bolt,
                          title: DashboardStrings.promoIntel,
                          description: DashboardStrings.promoIntelDesc,
                        ),
                        const SizedBox(height: 48),
                        Text(
                          DashboardStrings.promoFooter,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Bloc titre + paragraphe dans la feuille promo.
class DashboardPromoInfoSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const DashboardPromoInfoSection({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.accent, size: 28),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
