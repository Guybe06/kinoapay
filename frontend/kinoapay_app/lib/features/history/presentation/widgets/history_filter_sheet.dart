import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/history/application/bloc/history_bloc.dart";
import "package:kinoapay_app/features/history/application/bloc/history_event.dart";
import "package:kinoapay_app/features/history/application/bloc/history_state.dart";
import "package:kinoapay_app/features/history/domain/history_filter.dart";
import "package:kinoapay_app/features/history/domain/history_strings.dart";

/// Panneau de filtres, période, direction et canal.
/// Design monochrome, pas de couleurs opérateur.
/// Lit le filtre courant depuis [HistoryBloc] et l'actualise via [HistoryFilterChanged].
class HistoryFilterSheet extends StatelessWidget {
  const HistoryFilterSheet({super.key});

  void _dispatch(BuildContext context, HistoryFilter next) {
    context.read<HistoryBloc>().add(HistoryFilterChanged(next));
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HistoryBloc>().state;
    final filter =
        state is HistoryLoadSuccess ? state.filter : HistoryFilter.now();

    final isDefault = filter.direction == HistoryDirection.all &&
        filter.channel == null &&
        filter.isCurrentMonth;

    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(20, 0, 20, bottomInset + 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Handle(),
          _Header(
            isDefault: isDefault,
            onReset: () => _dispatch(context, HistoryFilter.now()),
            onClose: () => Navigator.pop(context),
          ),
          const SizedBox(height: 24),
          _PeriodSection(
            filter: filter,
            onChanged: (f) => _dispatch(context, f),
          ),
          const SizedBox(height: 24),
          _FilterSection(
            label: HistoryStrings.filterLabelDirection,
            child: _SegmentedSelector(
              options: const [
                HistoryStrings.dirAll,
                HistoryStrings.dirSent,
                HistoryStrings.dirReceived,
                HistoryStrings.dirPending,
              ],
              activeIndex: filter.direction.index,
              onSelect: (i) => _dispatch(
                context,
                filter.copyWith(direction: HistoryDirection.values[i]),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _FilterSection(
            label: HistoryStrings.filterLabelCanal,
            child: _SegmentedSelector(
              options: const [
                HistoryStrings.channelAll,
                HistoryStrings.channelMtn,
                HistoryStrings.channelAirtel,
              ],
              activeIndex: filter.channel == null
                  ? 0
                  : filter.channel == "MTN"
                      ? 1
                      : 2,
              onSelect: (i) => _dispatch(
                context,
                i == 0
                    ? filter.copyWith(clearChannel: true)
                    : filter.copyWith(channel: i == 1 ? "MTN" : "AIRTEL"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Handle extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          margin: const EdgeInsets.only(top: 12, bottom: 4),
          width: 32,
          height: 3,
          decoration: BoxDecoration(
            color: AppColors.quinoaDark.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );
}

class _Header extends StatelessWidget {
  final bool isDefault;
  final VoidCallback onReset;
  final VoidCallback onClose;

  const _Header({
    required this.isDefault,
    required this.onReset,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Row(
          children: [
            const Text(
              HistoryStrings.filterTitle,
              style: TextStyle(
                color: AppColors.quinoaDark,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              ),
            ),
            const Spacer(),
            if (!isDefault)
              GestureDetector(
                onTap: onReset,
                child: Text(
                  HistoryStrings.filterReset,
                  style: TextStyle(
                    color: AppColors.quinoaDark.withValues(alpha: 0.40),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            if (!isDefault) const SizedBox(width: 16),
            GestureDetector(
              onTap: onClose,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.quinoaDark.withValues(alpha: 0.06),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 15,
                  color: AppColors.quinoaDark.withValues(alpha: 0.45),
                ),
              ),
            ),
          ],
        ),
      );
}

/// Section avec label CAPS + contenu.
class _FilterSection extends StatelessWidget {
  final String label;
  final Widget child;

  const _FilterSection({required this.label, required this.child});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: AppColors.quinoaDark.withValues(alpha: 0.30),
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      );
}

/// Sélecteur segmenté monochrome — fond clair, segment actif en dark.
class _SegmentedSelector extends StatelessWidget {
  final List<String> options;
  final int activeIndex;
  final ValueChanged<int> onSelect;

  const _SegmentedSelector({
    required this.options,
    required this.activeIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.quinoaDark.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: List.generate(options.length, (i) {
          final isActive = i == activeIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.quinoaDark : Colors.transparent,
                  borderRadius: BorderRadius.circular(11),
                ),
                alignment: Alignment.center,
                child: Text(
                  options[i],
                  style: TextStyle(
                    color: isActive
                        ? Colors.white
                        : AppColors.quinoaDark.withValues(alpha: 0.45),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

/// Section période : navigation mois en haut, options 3 mois / année en bas.
class _PeriodSection extends StatelessWidget {
  final HistoryFilter filter;
  final ValueChanged<HistoryFilter> onChanged;

  const _PeriodSection({required this.filter, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isMonth = filter.period == HistoryPeriod.month;
    final raw = DateFormat("MMMM yyyy", "fr_FR")
        .format(DateTime(filter.year, filter.month));
    final monthLabel = raw[0].toUpperCase() + raw.substring(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          HistoryStrings.filterLabelPeriod.toUpperCase(),
          style: TextStyle(
            color: AppColors.quinoaDark.withValues(alpha: 0.30),
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 10),
        /// Navigateur mois
        GestureDetector(
          onTap: () => onChanged(filter.copyWith(period: HistoryPeriod.month)),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            decoration: BoxDecoration(
              color: isMonth
                  ? AppColors.quinoaDark
                  : AppColors.quinoaDark.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                _MonthArrow(
                  icon: Icons.chevron_left_rounded,
                  enabled: isMonth,
                  onTap: () => onChanged(filter.prevMonth()),
                  white: isMonth,
                ),
                Expanded(
                  child: Text(
                    isMonth ? monthLabel : HistoryStrings.periodMonth,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isMonth
                          ? Colors.white
                          : AppColors.quinoaDark.withValues(alpha: 0.45),
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                _MonthArrow(
                  icon: Icons.chevron_right_rounded,
                  enabled: isMonth && !filter.isCurrentMonth,
                  onTap: filter.isCurrentMonth
                      ? null
                      : () => onChanged(filter.nextMonth()),
                  white: isMonth,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        /// Options alternatives
        Row(
          children: [
            Expanded(
              child: _PeriodCard(
                label: HistoryStrings.period3Months,
                active: filter.period == HistoryPeriod.last3Months,
                onTap: () => onChanged(
                  filter.copyWith(period: HistoryPeriod.last3Months),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _PeriodCard(
                label: HistoryStrings.periodYear,
                active: filter.period == HistoryPeriod.thisYear,
                onTap: () => onChanged(
                  filter.copyWith(period: HistoryPeriod.thisYear),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PeriodCard extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _PeriodCard({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 13),
          decoration: BoxDecoration(
            color: active
                ? AppColors.quinoaDark
                : AppColors.quinoaDark.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: active
                  ? Colors.white
                  : AppColors.quinoaDark.withValues(alpha: 0.45),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
}

class _MonthArrow extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;
  final bool white;

  const _MonthArrow({
    required this.icon,
    required this.enabled,
    this.onTap,
    this.white = false,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: enabled ? onTap : null,
        child: Icon(
          icon,
          size: 20,
          color: white
              ? Colors.white.withValues(alpha: enabled ? 0.80 : 0.20)
              : AppColors.quinoaDark.withValues(alpha: enabled ? 0.40 : 0.15),
        ),
      );
}
