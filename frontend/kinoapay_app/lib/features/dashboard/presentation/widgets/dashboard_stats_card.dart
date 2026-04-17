import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/dashboard_strings.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/dashboard_stats.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_stats_card_widgets.dart";

/// Carte activité mensuelle light : solde XXL, résumé envoyé/reçu, courbes.
class DashboardStatsCard extends StatelessWidget {
  final DashboardStats stats;

  const DashboardStatsCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(
      symbol: "",
      decimalDigits: 0,
      locale: "fr_FR",
    );
    final rawMonth = DateFormat("MMMM yyyy", "fr_FR").format(DateTime.now());
    final month = rawMonth[0].toUpperCase() + rawMonth.substring(1);
    final balance = stats.totalReceived - stats.totalSent;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.quinoaDark.withValues(alpha: 0.06)),
        boxShadow: [
          BoxShadow(
            color: AppColors.quinoaDark.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DashboardStrings.balanceLabel,
                style: TextStyle(
                  color: AppColors.quinoaDark.withValues(alpha: 0.45),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
              _PeriodChip(label: month),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            fmt.format(balance).trim(),
            style: const TextStyle(
              color: AppColors.quinoaDark,
              fontSize: 42,
              fontWeight: FontWeight.w900,
              letterSpacing: -1.5,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            DashboardStrings.statsCurrency,
            style: TextStyle(
              color: AppColors.quinoaGold.withValues(alpha: 0.80),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: DashboardStatsValueBlock(
                  label: DashboardStrings.statsOutgoing,
                  amount: fmt.format(stats.totalSent).trim(),
                  color: AppColors.quinoaDark,
                ),
              ),
              Expanded(
                child: DashboardStatsValueBlock(
                  label: DashboardStrings.statsIncoming,
                  amount: fmt.format(stats.totalReceived).trim(),
                  color: AppColors.quinoaGold,
                  alignRight: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 64,
            width: double.infinity,
            child: CustomPaint(
              painter: DashboardStatsVolumePainter(volumes: stats.dailyVolumes),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              DashboardStatsLegendDot(
                color: AppColors.quinoaDark,
                label: DashboardStrings.statsLegendSent,
              ),
              const SizedBox(width: 16),
              DashboardStatsLegendDot(
                color: AppColors.quinoaGold,
                label: DashboardStrings.statsLegendReceived,
              ),
              const Spacer(),
              Text(
                DashboardStrings.statsLast30,
                style: TextStyle(
                  color: AppColors.quinoaDark.withValues(alpha: 0.30),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Chip de période dans la carte stats.
class _PeriodChip extends StatelessWidget {
  final String label;
  const _PeriodChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.quinoaDark.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.quinoaDark.withValues(alpha: 0.55),
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
