import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/helpers/screen_size_helper.dart";
import "package:kinoapay_app/features/dashboard/domain/dashboard_strings.dart";

/// Bottom sheet « En savoir plus » : texte marketing structuré.
class DashboardPromoDetailSheet extends StatelessWidget {
  const DashboardPromoDetailSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final compact = ScreenSizeHelper.isCompact(context);
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
                        AppColors.quinoaGold.withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(height: compact ? 10 : 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(height: compact ? 20 : 24),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: EdgeInsets.fromLTRB(
                        24,
                        0,
                        24,
                        ScreenSizeHelper.adaptiveValue(
                          context,
                          compact: 32,
                          small: 36,
                          medium: 38,
                          large: 40,
                        ),
                      ),
                      children: [
                        Text(
                          DashboardStrings.promoTitle,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: compact ? 28 : 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.0,
                            height: 1.1,
                          ),
                        ),
                        SizedBox(
                          height: ScreenSizeHelper.adaptiveValue(
                            context,
                            compact: 20,
                            small: 22,
                            medium: 24,
                            large: 24,
                          ),
                        ),
                        const DashboardPromoInfoSection(
                          icon: SolarIconsOutline.link,
                          title: DashboardStrings.promoLink,
                          description: DashboardStrings.promoLinkDesc,
                        ),
                        SizedBox(
                          height: ScreenSizeHelper.adaptiveValue(
                            context,
                            compact: 24,
                            small: 28,
                            medium: 30,
                            large: 32,
                          ),
                        ),
                        const DashboardPromoInfoSection(
                          icon: SolarIconsOutline.userId,
                          title: DashboardStrings.promoIdentity,
                          description: DashboardStrings.promoIdentityDesc,
                        ),
                        SizedBox(
                          height: ScreenSizeHelper.adaptiveValue(
                            context,
                            compact: 24,
                            small: 28,
                            medium: 30,
                            large: 32,
                          ),
                        ),
                        const DashboardPromoInfoSection(
                          icon: SolarIconsOutline.safeCircle,
                          title: DashboardStrings.promoProof,
                          description: DashboardStrings.promoProofDesc,
                        ),
                        SizedBox(
                          height: ScreenSizeHelper.adaptiveValue(
                            context,
                            compact: 24,
                            small: 28,
                            medium: 30,
                            large: 32,
                          ),
                        ),
                        const DashboardPromoInfoSection(
                          icon: SolarIconsOutline.bolt,
                          title: DashboardStrings.promoIntel,
                          description: DashboardStrings.promoIntelDesc,
                        ),
                        SizedBox(
                          height: ScreenSizeHelper.adaptiveValue(
                            context,
                            compact: 36,
                            small: 42,
                            medium: 45,
                            large: 48,
                          ),
                        ),
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
        Icon(icon, color: AppColors.quinoaGold, size: 28),
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
