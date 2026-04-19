import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/widgets/skeleton_box.dart";

/// Squelette animé de la card de statistiques (fond quinoaDark).
/// Reproduit exactement les dimensions et la structure de [DashboardStatsCard].
class DashboardStatsCardSkeleton extends StatelessWidget {
  const DashboardStatsCardSkeleton({super.key});

  static const Color _onDark = Color(0x22F5E6C8);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
      decoration: BoxDecoration(
        color: AppColors.quinoaDark,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              SkeletonBox(width: 90, height: 9, borderRadius: 4, color: _onDark),
              SkeletonBox(width: 80, height: 9, borderRadius: 4, color: _onDark),
            ],
          ),
          const SizedBox(height: 18),
          const SkeletonBox(
            width: double.infinity,
            height: 54,
            borderRadius: 8,
            color: _onDark,
          ),
          const SizedBox(height: 8),
          const SkeletonBox(width: 60, height: 10, borderRadius: 4, color: _onDark),
          const SizedBox(height: 20),
          Divider(
            color: AppColors.quinoaCream.withValues(alpha: 0.07),
            height: 1,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SkeletonBox(
                  width: double.infinity,
                  height: 36,
                  borderRadius: 6,
                  color: _onDark,
                ),
              ),
              Container(width: 1, height: 36, color: _onDark),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SkeletonBox(
                    width: double.infinity,
                    height: 36,
                    borderRadius: 6,
                    color: _onDark,
                  ),
                ),
              ),
              Container(width: 1, height: 36, color: _onDark),
              Expanded(
                child: SkeletonBox(
                  width: double.infinity,
                  height: 36,
                  borderRadius: 6,
                  color: _onDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Squelette animé de la section contacts récents.
/// Reproduit exactement la structure de [DashboardRecentContacts].
class DashboardRecentContactsSkeleton extends StatelessWidget {
  const DashboardRecentContactsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppColors.quinoaDark.withValues(alpha: 0.06),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.quinoaDark.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonBox(width: 110, height: 11, borderRadius: 5),
                SkeletonBox(width: 48, height: 10, borderRadius: 4),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 88,
              child: Row(
                children: List.generate(
                  5,
                  (i) => _ContactCircleSkeleton(isLast: i == 4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContactCircleSkeleton extends StatelessWidget {
  final bool isLast;
  const _ContactCircleSkeleton({required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: isLast ? 0 : 12),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SkeletonBox(width: 56, height: 56, borderRadius: 28),
          SizedBox(height: 6),
          SkeletonBox(width: 40, height: 9, borderRadius: 4),
        ],
      ),
    );
  }
}

/// Squelette d'une ligne de transaction — reproduit exactement [DashboardTxRow].
class DashboardTxRowSkeleton extends StatelessWidget {
  const DashboardTxRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          SkeletonBox(width: 42, height: 42, borderRadius: 21),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonBox(width: 120, height: 12, borderRadius: 5),
                SizedBox(height: 5),
                SkeletonBox(width: 90, height: 10, borderRadius: 4),
                SizedBox(height: 3),
                SkeletonBox(width: 60, height: 9, borderRadius: 4),
              ],
            ),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SkeletonBox(width: 64, height: 13, borderRadius: 5),
              SizedBox(height: 5),
              SkeletonBox(width: 32, height: 9, borderRadius: 4),
            ],
          ),
        ],
      ),
    );
  }
}
