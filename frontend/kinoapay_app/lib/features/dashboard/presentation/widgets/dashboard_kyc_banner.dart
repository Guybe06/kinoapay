import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/dashboard_strings.dart";

/// Bannière d'avertissement affiché quand la vérification KYC n'est pas complète.
/// Appuyer sur la bannière déclenche [onTap] (navigation vers le flux KYC).
class DashboardKycBanner extends StatelessWidget {
  final VoidCallback? onTap;

  const DashboardKycBanner({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.quinoaGold.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.quinoaGold.withValues(alpha: 0.30),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              SolarIconsOutline.infoCircle,
              size: 20,
              color: AppColors.quinoaGold,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    DashboardStrings.kycBannerTitle,
                    style: TextStyle(
                      color: AppColors.quinoaDark,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DashboardStrings.kycBannerMessage,
                    style: TextStyle(
                      color: AppColors.quinoaDark.withValues(alpha: 0.60),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              SolarIconsOutline.altArrowRight,
              size: 14,
              color: AppColors.quinoaGold.withValues(alpha: 0.70),
            ),
          ],
        ),
      ),
    );
  }
}
