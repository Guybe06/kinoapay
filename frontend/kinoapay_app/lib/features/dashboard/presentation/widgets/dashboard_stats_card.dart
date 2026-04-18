import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/dashboard_strings.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/dashboard_stats.dart";

/// Carte solde hero — fond quinoaDark, montant centré w300, stats sortant/entrant.
class DashboardStatsCard extends StatelessWidget {
  final DashboardStats stats;

  const DashboardStatsCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat("#,##0", "en_US");
    final rawMonth = DateFormat("MMMM yyyy", "fr_FR").format(DateTime.now());
    final month = rawMonth[0].toUpperCase() + rawMonth.substring(1);
    final balance = stats.totalReceived - stats.totalSent;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 22),
      decoration: BoxDecoration(
        color: AppColors.quinoaDark,
        borderRadius: BorderRadius.circular(28),
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
                  color: AppColors.quinoaCream.withValues(alpha: 0.45),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              _PeriodChip(label: month),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            fmt.format(balance).trim(),
            style: const TextStyle(
              color: AppColors.quinoaCream,
              fontSize: 52,
              fontWeight: FontWeight.w300,
              letterSpacing: -2,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            DashboardStrings.statsCurrency,
            style: TextStyle(
              color: AppColors.quinoaCream.withValues(alpha: 0.30),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 20),
          Divider(
            color: AppColors.quinoaCream.withValues(alpha: 0.08),
            height: 1,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _StatBlock(
                  label: DashboardStrings.statsOutgoing,
                  amount: fmt.format(stats.totalSent).trim(),
                  icon: SolarIconsOutline.arrowRightUp,
                  color: AppColors.quinoaCream.withValues(alpha: 0.70),
                ),
              ),
              Container(
                width: 1,
                height: 38,
                color: AppColors.quinoaCream.withValues(alpha: 0.08),
              ),
              Expanded(
                child: _StatBlock(
                  label: DashboardStrings.statsIncoming,
                  amount: fmt.format(stats.totalReceived).trim(),
                  icon: SolarIconsOutline.arrowLeftDown,
                  color: AppColors.quinoaGold,
                  alignRight: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PeriodChip extends StatelessWidget {
  final String label;
  const _PeriodChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.quinoaCream.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.quinoaCream.withValues(alpha: 0.55),
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _StatBlock extends StatelessWidget {
  final String label;
  final String amount;
  final IconData icon;
  final Color color;
  final bool alignRight;

  const _StatBlock({
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    final cross =
        alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final mainAlign =
        alignRight ? MainAxisAlignment.end : MainAxisAlignment.start;

    return Padding(
      padding: EdgeInsets.only(
        left: alignRight ? 20 : 0,
        right: alignRight ? 0 : 20,
      ),
      child: Column(
        crossAxisAlignment: cross,
        children: [
          Row(
            mainAxisAlignment: mainAlign,
            children: [
              if (!alignRight) ...[
                Icon(icon, size: 13, color: color),
                const SizedBox(width: 5),
              ],
              Text(
                label,
                style: TextStyle(
                  color: color.withValues(alpha: 0.7),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (alignRight) ...[
                const SizedBox(width: 5),
                Icon(icon, size: 13, color: color),
              ],
            ],
          ),
          const SizedBox(height: 5),
          Text(
            amount,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}
