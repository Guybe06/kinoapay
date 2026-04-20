import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/navigation/presentation/widgets/app_back_header.dart";
import "package:kinoapay_app/core/widgets/app_page_title.dart";
import "package:kinoapay_app/core/widgets/app_scroll_scaffold.dart";
import "package:kinoapay_app/features/history/application/bloc/history_bloc.dart";
import "package:kinoapay_app/features/history/application/bloc/history_event.dart";
import "package:kinoapay_app/features/history/application/bloc/history_state.dart";
import "package:kinoapay_app/features/history/domain/history_filter.dart";
import "package:kinoapay_app/features/history/domain/history_strings.dart";
import "package:kinoapay_app/features/history/presentation/widgets/history_filter_sheet.dart";
import "package:kinoapay_app/features/history/presentation/widgets/history_stats_bar.dart";
import "package:kinoapay_app/features/history/presentation/widgets/history_tx_list.dart";

/// Écran Historique : header scroll-hide, filtres via sheet, stats et liste paginée.
class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  @override
  void initState() {
    super.initState();
    context.read<HistoryBloc>().add(const HistoryStarted());
  }

  void _openFilterSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<HistoryBloc>(),
        child: const HistoryFilterSheet(),
      ),
    );
  }

  bool _hasActiveFilters(HistoryFilter filter) =>
      filter.direction != HistoryDirection.all ||
      filter.channel != null ||
      !filter.isCurrentMonth;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HistoryBloc>().state;
    final filter = state is HistoryLoadSuccess
        ? state.filter
        : HistoryFilter.now();
    final filtersActive = _hasActiveFilters(filter);

    return AppScrollScaffold(
      onNearBottom: () =>
          context.read<HistoryBloc>().add(const HistoryMoreRequested()),
      header: AppBackHeader(
        onBack: () => Navigator.pop(context),
        backLabel: HistoryStrings.backLabel,
        title: HistoryStrings.title,
        subtitle: HistoryStrings.headerSubtitle,
        trailing: _FilterButton(
          active: filtersActive,
          onTap: () => _openFilterSheet(context),
        ),
      ),
      builder: (_, ctrl) => CustomScrollView(
        controller: ctrl,
        physics: const BouncingScrollPhysics(),
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 52)),
          const SliverToBoxAdapter(
            child: AppPageTitle(
              title: HistoryStrings.pageTitle,
              subtitle: HistoryStrings.pageSubtitle,
            ),
          ),
          if (state is HistoryLoadSuccess) ...[
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(child: HistoryStatsBar(state: state)),
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            HistoryTxList(
              transactions: state.displayed,
              hasMore: state.hasMore,
            ),
          ] else if (state is HistoryLoading) ...[
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.quinoaDark,
                  strokeWidth: 2,
                ),
              ),
            ),
          ] else if (state is HistoryLoadFailure) ...[
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(
                  HistoryStrings.errorLoad,
                  style: TextStyle(
                    color: AppColors.quinoaDark.withValues(alpha: 0.40),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Bouton filtre avec badge doré quand des filtres non-défaut sont actifs.
class _FilterButton extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;

  const _FilterButton({required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: active
                  ? AppColors.quinoaDark
                  : AppColors.quinoaDark.withValues(alpha: 0.06),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.tune_rounded,
              size: 17,
              color: active
                  ? Colors.white
                  : AppColors.quinoaDark.withValues(alpha: 0.55),
            ),
          ),
          if (active)
            Positioned(
              top: -1,
              right: -1,
              child: Container(
                width: 9,
                height: 9,
                decoration: BoxDecoration(
                  color: AppColors.quinoaGold,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
