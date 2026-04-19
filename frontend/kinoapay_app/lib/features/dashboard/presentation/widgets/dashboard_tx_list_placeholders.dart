import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/dashboard_strings.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_card_skeletons.dart";

/// Squelette de la liste de transactions — reproduit [DashboardTxRow] × 5.
class DashboardTxListSkeleton extends StatelessWidget {
  const DashboardTxListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.quinoaDark.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: List.generate(5, (i) {
          final isLast = i == 4;
          return Column(
            children: [
              const DashboardTxRowSkeleton(),
              if (!isLast)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.quinoaDark.withValues(alpha: 0.04),
                  ),
                ),
            ],
          );
        }),
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
