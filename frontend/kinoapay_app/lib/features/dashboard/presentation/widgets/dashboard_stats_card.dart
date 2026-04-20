import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:solar_icons/solar_icons.dart";
import "package:intl/intl.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_bloc.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_event.dart";
import "package:kinoapay_app/features/dashboard/domain/dashboard_strings.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/dashboard_stats.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_stats_card_controls.dart";

/// Carte principale des statistiques mensuelles avec navigation de période.
final _fmt = NumberFormat("#,##0", "en_US");

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
      DashboardPeriodChanged(month: _month, year: _year),
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
      DashboardPeriodChanged(month: _month, year: _year),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              DashboardStatsMonthNavigator(
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
                  _fmt.format(net.abs()),
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
                child: DashboardStatsDeltaBadge(isPositive: isPositive),
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
                child: DashboardStatsStatColumn(
                  label: DashboardStrings.statsOutgoing,
                  amount: _fmt.format(widget.stats.totalSent),
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
                child: DashboardStatsStatColumn(
                  label: DashboardStrings.statsIncoming,
                  amount: _fmt.format(widget.stats.totalReceived),
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
                child: DashboardStatsStatColumn(
                  label: DashboardStrings.statsNet,
                  amount:
                      "${isPositive ? "+" : "−"}${_fmt.format(net.abs())}",
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
