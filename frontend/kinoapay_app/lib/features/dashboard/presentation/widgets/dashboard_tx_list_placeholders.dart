import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/dashboard_strings.dart";

/// Placeholders alignés sur la hauteur d’une ligne de transaction.
class DashboardTxListSkeleton extends StatelessWidget {
  const DashboardTxListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        5,
        (i) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            height: 74,
            decoration: BoxDecoration(
              color: AppColors.quinoaDark.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: AppColors.quinoaDark.withValues(alpha: 0.06),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Affichage lorsque la liste récente est vide.
class DashboardTxListEmpty extends StatelessWidget {
  const DashboardTxListEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(
            SolarIconsOutline.history,
            size: 30,
            color: AppColors.quinoaDark.withValues(alpha: 0.25),
          ),
          const SizedBox(height: 12),
          Text(
            DashboardStrings.noTx,
            style: TextStyle(
              color: AppColors.quinoaDark.withValues(alpha: 0.40),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
