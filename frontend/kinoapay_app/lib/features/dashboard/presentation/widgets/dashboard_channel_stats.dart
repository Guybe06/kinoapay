import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/dashboard_strings.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/channel_stat.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_channel_card.dart";

/// Répartition des flux par canal de paiement — style terminal financier.
/// Délègue le rendu de chaque carte à [DashboardChannelCard].
class DashboardChannelStats extends StatelessWidget {
  final List<ChannelStat> stats;

  const DashboardChannelStats({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    if (stats.isEmpty) return const SizedBox.shrink();

    final totalVolume = stats.fold<double>(0, (s, e) => s + e.total);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DashboardStrings.channelSection.toUpperCase(),
                style: TextStyle(
                  color: AppColors.quinoaDark.withValues(alpha: 0.35),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.6,
                ),
              ),
              Text(
                DashboardStrings.statsCurrency,
                style: TextStyle(
                  color: AppColors.quinoaDark.withValues(alpha: 0.25),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: stats.asMap().entries.map((e) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: e.key > 0 ? 10 : 0),
                  child: DashboardChannelCard(
                    stat: e.value,
                    sharePercent: totalVolume > 0 ? e.value.total / totalVolume : 0,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
