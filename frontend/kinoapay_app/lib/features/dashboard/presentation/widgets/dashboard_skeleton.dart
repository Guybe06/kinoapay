import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/navigation/presentation/widgets/app_header.dart";
import "package:kinoapay_app/core/widgets/skeleton_box.dart";
import "package:kinoapay_app/features/dashboard/domain/dashboard_strings.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_card_skeletons.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_home_widgets.dart";

/// Skeleton complet du tableau de bord — remplace [_DashboardSkeleton].
/// Reproduit fidèlement l'ensemble du layout chargé.
class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.quinoaCream,
      appBar: const AppHeader(),
      body: Stack(
        children: [
          const DashboardAmbientBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const DashboardGreetingSection(firstName: ""),
                  const SizedBox(height: 24),
                  const DashboardStatsCardSkeleton(),
                  const SizedBox(height: 20),
                  _buildActionsSkeleton(),
                  const SizedBox(height: 20),
                  _buildPromoSkeleton(),
                  const SizedBox(height: 20),
                  const DashboardRecentContactsSkeleton(),
                  const SizedBox(height: 24),
                  _buildTxSectionSkeleton(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: SkeletonBox(
              width: double.infinity,
              height: 52,
              borderRadius: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SkeletonBox(
              width: double.infinity,
              height: 52,
              borderRadius: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoSkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SkeletonBox(
        width: double.infinity,
        height: 140,
        borderRadius: 32,
        color: AppColors.quinoaDark.withValues(alpha: 0.10),
      ),
    );
  }

  Widget _buildTxSectionSkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DashboardStrings.lastTx,
                style: TextStyle(
                  color: AppColors.quinoaDark.withValues(alpha: 0.85),
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
              const SkeletonBox(width: 48, height: 11, borderRadius: 4),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: AppColors.quinoaDark.withValues(alpha: 0.05),
              ),
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
          ),
        ],
      ),
    );
  }
}
