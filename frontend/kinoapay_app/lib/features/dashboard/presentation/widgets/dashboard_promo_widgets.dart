import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/dashboard_strings.dart";

/// Bannière promo compacte — accent gold, format horizontal, non intrusif.
class DashboardPromoCard extends StatelessWidget {
  final VoidCallback onTap;
  const DashboardPromoCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.quinoaGold.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.quinoaGold.withValues(alpha: 0.8),
              width: 0.8,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.quinoaGold.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  SolarIconsOutline.plain,
                  size: 18,
                  color: AppColors.quinoaCream,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      DashboardStrings.promoLink,
                      style: TextStyle(
                        color: AppColors.quinoaDark,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      DashboardStrings.promoCta,
                      style: TextStyle(
                        color: AppColors.quinoaDark.withValues(alpha: 1),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                SolarIconsOutline.altArrowRight,
                size: 16,
                color: AppColors.quinoaDark.withValues(alpha: 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
