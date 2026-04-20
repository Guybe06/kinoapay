import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/history/application/bloc/history_bloc.dart";
import "package:kinoapay_app/features/history/application/bloc/history_event.dart";
import "package:kinoapay_app/features/history/domain/history_filter.dart";
import "package:kinoapay_app/features/history/domain/history_strings.dart";

/// Sheet de filtrage — période, direction et canal.
///
/// Chaque sélection est appliquée immédiatement via [HistoryFilterChanged].
class HistoryFilterSheet extends StatelessWidget {
  final HistoryFilter filter;

  const HistoryFilterSheet({super.key, required this.filter});

  void _dispatch(BuildContext context, HistoryFilter next) {
    context.read<HistoryBloc>().add(HistoryFilterChanged(next));
  }

  @override
  Widget build(BuildContext context) {
    final isDefaultFilter = filter.direction == HistoryDirection.all &&
        filter.channel == null &&
        filter.isCurrentMonth;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Handle(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 16, 20),
            child: Row(
              children: [
                const Text(
                  "Filtres",
                  style: TextStyle(
                    color: AppColors.quinoaDark,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.4,
                  ),
                ),
                const Spacer(),
                if (!isDefaultFilter)
                  GestureDetector(
                    onTap: () => _dispatch(context, HistoryFilter.now()),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.quinoaDark.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        "Réinitialiser",
                        style: TextStyle(
                          color: AppColors.quinoaDark.withValues(alpha: 0.55),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.quinoaDark.withValues(alpha: 0.06),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 16,
                      color: AppColors.quinoaDark.withValues(alpha: 0.50),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _Section(label: "Période", child: _PeriodRow(filter: filter, onChanged: (f) => _dispatch(context, f))),
          const SizedBox(height: 20),
          _Section(label: "Direction", child: _ChipRow(children: _directionChips(context))),
          const SizedBox(height: 20),
          _Section(label: "Canal", child: _ChipRow(children: _channelChips(context))),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  List<Widget> _directionChips(BuildContext context) => [
    _Chip(
      label: HistoryStrings.dirAll,
      active: filter.direction == HistoryDirection.all,
      onTap: () => _dispatch(context, filter.copyWith(direction: HistoryDirection.all)),
    ),
    _Chip(
      label: HistoryStrings.dirSent,
      active: filter.direction == HistoryDirection.sent,
      onTap: () => _dispatch(context, filter.copyWith(direction: HistoryDirection.sent)),
    ),
    _Chip(
      label: HistoryStrings.dirReceived,
      active: filter.direction == HistoryDirection.received,
      onTap: () => _dispatch(context, filter.copyWith(direction: HistoryDirection.received)),
    ),
    _Chip(
      label: HistoryStrings.dirPending,
      active: filter.direction == HistoryDirection.pending,
      onTap: () => _dispatch(context, filter.copyWith(direction: HistoryDirection.pending)),
    ),
  ];

  List<Widget> _channelChips(BuildContext context) => [
    _Chip(
      label: HistoryStrings.channelAll,
      active: filter.channel == null,
      onTap: () => _dispatch(context, filter.copyWith(clearChannel: true)),
    ),
    _Chip(
      label: "MTN",
      active: filter.channel == "MTN",
      dot: AppColors.mtnYellow,
      onTap: () => _dispatch(context, filter.copyWith(channel: "MTN")),
    ),
    _Chip(
      label: "Airtel",
      active: filter.channel == "AIRTEL",
      dot: AppColors.airtelRed,
      onTap: () => _dispatch(context, filter.copyWith(channel: "AIRTEL")),
    ),
  ];
}

class _Handle extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          margin: const EdgeInsets.only(top: 12, bottom: 8),
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.quinoaDark.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );
}

class _Section extends StatelessWidget {
  final String label;
  final Widget child;
  const _Section({required this.label, required this.child});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: Text(
              label.toUpperCase(),
              style: TextStyle(
                color: AppColors.quinoaDark.withValues(alpha: 0.35),
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
              ),
            ),
          ),
          child,
        ],
      );
}

/// Navigation période avec flèches mois + chips.
class _PeriodRow extends StatelessWidget {
  final HistoryFilter filter;
  final ValueChanged<HistoryFilter> onChanged;
  const _PeriodRow({required this.filter, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isMonth = filter.period == HistoryPeriod.month;
    final raw = DateFormat("MMM yyyy", "fr_FR")
        .format(DateTime(filter.year, filter.month));
    final monthLabel = raw[0].toUpperCase() + raw.substring(1);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          if (isMonth) ...[
            _NavArrow(
              icon: SolarIconsOutline.altArrowLeft,
              onTap: () => onChanged(filter.prevMonth()),
            ),
            const SizedBox(width: 4),
          ],
          _Chip(
            label: isMonth ? monthLabel : HistoryStrings.periodMonth,
            active: isMonth,
            onTap: () => onChanged(filter.copyWith(period: HistoryPeriod.month)),
          ),
          if (isMonth) ...[
            const SizedBox(width: 4),
            _NavArrow(
              icon: SolarIconsOutline.altArrowRight,
              onTap: filter.isCurrentMonth ? null : () => onChanged(filter.nextMonth()),
              enabled: !filter.isCurrentMonth,
            ),
          ],
          const SizedBox(width: 8),
          _Chip(
            label: HistoryStrings.period3Months,
            active: filter.period == HistoryPeriod.last3Months,
            onTap: () => onChanged(filter.copyWith(period: HistoryPeriod.last3Months)),
          ),
          const SizedBox(width: 8),
          _Chip(
            label: HistoryStrings.periodYear,
            active: filter.period == HistoryPeriod.thisYear,
            onTap: () => onChanged(filter.copyWith(period: HistoryPeriod.thisYear)),
          ),
        ],
      ),
    );
  }
}

class _ChipRow extends StatelessWidget {
  final List<Widget> children;
  const _ChipRow({required this.children});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: children
              .expand((c) => [c, const SizedBox(width: 8)])
              .toList()
            ..removeLast(),
        ),
      );
}

class _Chip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  final Color? dot;

  const _Chip({
    required this.label,
    required this.active,
    required this.onTap,
    this.dot,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: active ? AppColors.quinoaDark : AppColors.quinoaDark.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: active
                  ? AppColors.quinoaDark
                  : AppColors.quinoaDark.withValues(alpha: 0.08),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (dot != null) ...[
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: active ? Colors.white.withValues(alpha: 0.7) : dot,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
              ],
              Text(
                label,
                style: TextStyle(
                  color: active
                      ? Colors.white
                      : AppColors.quinoaDark.withValues(alpha: 0.55),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
}

class _NavArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool enabled;

  const _NavArrow({required this.icon, this.onTap, this.enabled = true});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: AppColors.quinoaDark.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: AppColors.quinoaDark.withValues(alpha: 0.08),
            ),
          ),
          child: Icon(
            icon,
            size: 13,
            color: enabled
                ? AppColors.quinoaDark.withValues(alpha: 0.55)
                : AppColors.quinoaDark.withValues(alpha: 0.18),
          ),
        ),
      );
}
