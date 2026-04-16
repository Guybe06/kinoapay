import "dart:ui";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/dashboard_strings.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/dashboard_stats.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_stats_card_widgets.dart";

/// Carte « activité mensuelle » : totaux reçu / envoyé et courbes sur 30 jours.
class DashboardStatsCard extends StatelessWidget {
  final DashboardStats stats;

  const DashboardStatsCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(
      symbol: "",
      decimalDigits: 0,
      locale: "fr_FR",
    );
    final rawMonth = DateFormat("MMMM yyyy", "fr_FR").format(DateTime.now());
    final month = rawMonth[0].toUpperCase() + rawMonth.substring(1);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.quinoaDark.withValues(alpha: 0.90),
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.12),
                  width: 1.5,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DashboardStrings.statsMonthlyTitle,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          month,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.95),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DashboardStatsValueBlock(
                          label: DashboardStrings.statsIncoming,
                          amount: currency.format(stats.totalReceived).trim(),
                          color: AppColors.quinoaGold.withValues(alpha: 0.7),
                        ),
                      ),
                      Expanded(
                        child: DashboardStatsValueBlock(
                          label: DashboardStrings.statsOutgoing,
                          amount: currency.format(stats.totalSent).trim(),
                          color: Colors.white.withValues(alpha: 0.7),
                          alignRight: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 72,
                    width: double.infinity,
                    child: CustomPaint(
                      painter: DashboardStatsVolumePainter(
                        volumes: stats.dailyVolumes,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      DashboardStatsLegendDot(
                        color: AppColors.quinoaGold.withValues(alpha: 0.7),
                        label: DashboardStrings.statsLegendReceived,
                      ),
                      const SizedBox(width: 16),
                      DashboardStatsLegendDot(
                        color: Colors.white.withValues(alpha: 0.7),
                        label: DashboardStrings.statsLegendSent,
                      ),
                      const Spacer(),
                      Text(
                        DashboardStrings.statsLast30,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.60),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
