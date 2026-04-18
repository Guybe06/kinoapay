import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/dashboard_strings.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/dashboard_stats.dart";

class DashboardStatsCard extends StatelessWidget {
  final DashboardStats stats;

  const DashboardStatsCard({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat("#,##0", "en_US");
    final rawMonth = DateFormat("MMMM yyyy", "fr_FR").format(DateTime.now());
    final month = rawMonth[0].toUpperCase() + rawMonth.substring(1);
    final net = stats.netFlow;
    final isPositive = net >= 0;

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
            children: [
              Text(
                DashboardStrings.balanceLabel.toUpperCase(),
                style: TextStyle(
                  color: AppColors.quinoaCream.withValues(alpha: 0.35),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.4,
                ),
              ),
              _PeriodTabs(currentMonth: month),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  fmt.format(net.abs()),
                  style: const TextStyle(
                    color: AppColors.quinoaCream,
                    fontSize: 52,
                    fontWeight: FontWeight.w300,
                    letterSpacing: -2,
                    height: 1.0,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: _DeltaBadge(isPositive: isPositive),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            DashboardStrings.statsCurrency,
            style: TextStyle(
              color: AppColors.quinoaCream.withValues(alpha: 0.28),
              fontSize: 13,
              fontWeight: FontWeight.w400,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 20),
          Divider(color: AppColors.quinoaCream.withValues(alpha: 0.07), height: 1),
          const SizedBox(height: 16),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: _StatColumn(
                    label: DashboardStrings.statsOutgoing,
                    amount: fmt.format(stats.totalSent),
                    icon: SolarIconsOutline.arrowRightUp,
                    color: AppColors.quinoaCream.withValues(alpha: 0.65),
                  ),
                ),
                VerticalDivider(
                  color: AppColors.quinoaCream.withValues(alpha: 0.08),
                  width: 1,
                  thickness: 1,
                ),
                Expanded(
                  child: _StatColumn(
                    label: DashboardStrings.statsIncoming,
                    amount: fmt.format(stats.totalReceived),
                    icon: SolarIconsOutline.arrowLeftDown,
                    color: AppColors.quinoaGold,
                    center: true,
                  ),
                ),
                VerticalDivider(
                  color: AppColors.quinoaCream.withValues(alpha: 0.08),
                  width: 1,
                  thickness: 1,
                ),
                Expanded(
                  child: _StatColumn(
                    label: DashboardStrings.statsNet,
                    amount: "${isPositive ? "+" : "−"}${fmt.format(net.abs())}",
                    icon: isPositive
                        ? SolarIconsOutline.graphUp
                        : SolarIconsOutline.graphDown,
                    color: isPositive
                        ? AppColors.quinoaGold
                        : AppColors.quinoaRed.withValues(alpha: 0.85),
                    alignRight: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodTabs extends StatelessWidget {
  final String currentMonth;
  const _PeriodTabs({required this.currentMonth});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _Tab(label: "M", active: true),
        const SizedBox(width: 14),
        _Tab(label: "3M"),
        const SizedBox(width: 14),
        _Tab(label: "12M"),
      ],
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool active;
  const _Tab({required this.label, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: active
            ? AppColors.quinoaCream.withValues(alpha: 0.90)
            : AppColors.quinoaCream.withValues(alpha: 0.22),
        fontSize: 11,
        fontWeight: active ? FontWeight.w700 : FontWeight.w500,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _DeltaBadge extends StatelessWidget {
  final bool isPositive;
  const _DeltaBadge({required this.isPositive});

  @override
  Widget build(BuildContext context) {
    final color = isPositive ? AppColors.quinoaGold : AppColors.quinoaRed;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
            size: 10,
            color: color,
          ),
          const SizedBox(width: 3),
          Text(
            isPositive ? "NET +" : "NET −",
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String label;
  final String amount;
  final IconData icon;
  final Color color;
  final bool center;
  final bool alignRight;

  const _StatColumn({
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
    this.center = false,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    final cross = alignRight
        ? CrossAxisAlignment.end
        : center
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start;

    final pad = EdgeInsets.only(
      left: alignRight ? 16 : center ? 0 : 0,
      right: alignRight ? 0 : center ? 0 : 16,
    );

    return Padding(
      padding: pad,
      child: Column(
        crossAxisAlignment: cross,
        children: [
          Row(
            mainAxisAlignment: alignRight
                ? MainAxisAlignment.end
                : center
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
            children: [
              Icon(icon, size: 11, color: color.withValues(alpha: 0.70)),
              const SizedBox(width: 4),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  color: color.withValues(alpha: 0.55),
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            amount,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
