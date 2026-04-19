import "package:flutter/material.dart";
import "package:kinoapay_app/core/widgets/skeleton_box.dart";

/// Squelette animé de [DashboardChannelStats] — reproduit la structure des deux cartes canal.
class DashboardChannelStatsSkeleton extends StatelessWidget {
  const DashboardChannelStatsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _ChannelCardSkeleton()),
          const SizedBox(width: 10),
          Expanded(child: _ChannelCardSkeleton()),
        ],
      ),
    );
  }
}

class _ChannelCardSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x0F1A1A2E)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SkeletonBox(width: 7, height: 7, borderRadius: 4),
              SizedBox(width: 6),
              Expanded(child: SkeletonBox(width: double.infinity, height: 9, borderRadius: 4)),
              SizedBox(width: 8),
              SkeletonBox(width: 30, height: 16, borderRadius: 6),
            ],
          ),
          SizedBox(height: 10),
          SkeletonBox(width: double.infinity, height: 52, borderRadius: 8),
          SizedBox(height: 10),
          SkeletonBox(width: 80, height: 13, borderRadius: 4),
          SizedBox(height: 4),
          SkeletonBox(width: 50, height: 9, borderRadius: 4),
          SizedBox(height: 10),
          SkeletonBox(width: double.infinity, height: 3, borderRadius: 3),
        ],
      ),
    );
  }
}
