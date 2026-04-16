import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/dashboard_strings.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/channel_stat.dart";

/// Répartition des flux par canal de paiement (MTN, Airtel…).
class DashboardChannelStats extends StatelessWidget {
  final List<ChannelStat> stats;

  const DashboardChannelStats({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    if (stats.isEmpty) return const SizedBox.shrink();

    final totalVolume = stats.fold<double>(0, (sum, s) => sum + s.total);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                DashboardStrings.channelSection,
                style: TextStyle(
                  color: AppColors.quinoaDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  DashboardStrings.seeMore,
                  style: const TextStyle(
                    color: AppColors.quinoaGold,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: stats.asMap().entries.map((entry) {
              final i = entry.key;
              final stat = entry.value;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: i > 0 ? 8 : 0),
                  child: _ChannelCard(
                    stat: stat,
                    sharePercent: totalVolume > 0
                        ? stat.total / totalVolume
                        : 0,
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

class _ChannelCard extends StatelessWidget {
  final ChannelStat stat;
  final double sharePercent;

  const _ChannelCard({required this.stat, required this.sharePercent});

  Color get _brandColor => AppColors.quinoaGold;

  @override
  Widget build(BuildContext context) {
    final compact = NumberFormat.compact(locale: "fr_FR");
    final brand = _brandColor;
    final netPositive = stat.net >= 0;
    final netColor = netPositive ? AppColors.accentDark : AppColors.quinoaDark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.quinoaDark.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: AppColors.quinoaDark.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: brand, shape: BoxShape.circle),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  stat.type,
                  style: const TextStyle(
                    color: AppColors.quinoaDark,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          Text(
            "${compact.format(stat.total)} XAF",
            style: const TextStyle(
              color: AppColors.quinoaDark,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
            ),
          ),

          const SizedBox(height: 2),

          Row(
            children: [
              Text(
                netPositive ? "↑" : "↓",
                style: TextStyle(
                  color: netColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 2),
              Text(
                "${compact.format(stat.net.abs())} net",
                style: TextStyle(
                  color: netColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: sharePercent,
              minHeight: 4,
              backgroundColor: brand.withValues(alpha: 0.12),
              valueColor: AlwaysStoppedAnimation<Color>(
                brand.withValues(alpha: 0.75),
              ),
            ),
          ),

          const SizedBox(height: 8),

          Text(
            DashboardStrings.txCountLabel(stat.txCount),
            style: TextStyle(
              color: AppColors.quinoaDark.withValues(alpha: 0.40),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
