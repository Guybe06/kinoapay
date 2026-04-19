import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_bloc.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_event.dart";
import "package:kinoapay_app/features/dashboard/domain/dashboard_strings.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/dashboard_stats.dart";

class DashboardStatsCard extends StatefulWidget {
  final DashboardStats stats;

  const DashboardStatsCard({super.key, required this.stats});

  @override
  State<DashboardStatsCard> createState() => _DashboardStatsCardState();
}

class _DashboardStatsCardState extends State<DashboardStatsCard> {
  late int _month;
  late int _year;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = now.month;
    _year = now.year;
  }

  bool get _isCurrentPeriod {
    final now = DateTime.now();
    return _month == now.month && _year == now.year;
  }

  void _prev() {
    setState(() {
      if (_month == 1) {
        _month = 12;
        _year--;
      } else {
        _month--;
      }
    });
    context.read<DashboardBloc>().add(
      DashboardStarted(month: _month, year: _year),
    );
  }

  void _next() {
    if (_isCurrentPeriod) return;
    setState(() {
      if (_month == 12) {
        _month = 1;
        _year++;
      } else {
        _month++;
      }
    });
    context.read<DashboardBloc>().add(
      DashboardStarted(month: _month, year: _year),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat("#,##0", "en_US");
    final net = widget.stats.netFlow;
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
              _MonthNavigator(
                month: _month,
                year: _year,
                canGoNext: !_isCurrentPeriod,
                onPrev: _prev,
                onNext: _next,
              ),
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
          Divider(
            color: AppColors.quinoaCream.withValues(alpha: 0.07),
            height: 1,
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _StatColumn(
                  label: DashboardStrings.statsOutgoing,
                  amount: fmt.format(widget.stats.totalSent),
                  icon: SolarIconsOutline.arrowRightUp,
                  color: AppColors.quinoaCream.withValues(alpha: 0.65),
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.quinoaCream.withValues(alpha: 0.08),
              ),
              Expanded(
                child: _StatColumn(
                  label: DashboardStrings.statsIncoming,
                  amount: fmt.format(widget.stats.totalReceived),
                  icon: SolarIconsOutline.arrowLeftDown,
                  color: AppColors.quinoaGold,
                  center: true,
                ),
              ),
              Container(
                width: 1,
                height: 40,
                color: AppColors.quinoaCream.withValues(alpha: 0.08),
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
        ],
      ),
    );
  }
}

class _MonthNavigator extends StatelessWidget {
  final int month;
  final int year;
  final bool canGoNext;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _MonthNavigator({
    required this.month,
    required this.year,
    required this.canGoNext,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final raw = DateFormat("MMM yyyy", "fr_FR").format(DateTime(year, month));
    final label = raw[0].toUpperCase() + raw.substring(1);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _NavArrow(
          icon: SolarIconsOutline.altArrowLeft,
          onTap: onPrev,
          enabled: true,
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: AppColors.quinoaCream.withValues(alpha: 0.70),
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(width: 6),
        _NavArrow(
          icon: SolarIconsOutline.altArrowRight,
          onTap: onNext,
          enabled: canGoNext,
        ),
      ],
    );
  }
}

class _NavArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  const _NavArrow({
    required this.icon,
    required this.onTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Icon(
        icon,
        size: 13,
        color: enabled
            ? AppColors.quinoaCream.withValues(alpha: 0.55)
            : AppColors.quinoaCream.withValues(alpha: 0.15),
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
            isPositive
                ? Icons.arrow_upward_rounded
                : Icons.arrow_downward_rounded,
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
      left: center || alignRight ? 16 : 0,
      right: center || !alignRight ? 16 : 0,
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
