import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/history/application/bloc/history_bloc.dart";
import "package:kinoapay_app/features/history/application/bloc/history_event.dart";
import "package:kinoapay_app/features/history/application/bloc/history_state.dart";
import "package:kinoapay_app/features/history/domain/history_filter.dart";
import "package:kinoapay_app/features/history/domain/history_strings.dart";
import "package:kinoapay_app/features/history/presentation/widgets/history_filter_sheet.dart";
import "package:kinoapay_app/core/navigation/presentation/widgets/app_back_header.dart";
import "package:kinoapay_app/core/widgets/app_page_title.dart";
import "package:kinoapay_app/features/history/presentation/widgets/history_stats_bar.dart";
import "package:kinoapay_app/features/history/presentation/widgets/history_tx_list.dart";

/// Écran Historique — header scroll-hide, filtres via sheet, stats et liste.
class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  final _scrollController = ScrollController();
  bool _headerVisible = true;
  double _lastOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<HistoryBloc>().add(const HistoryStarted());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scrollController.offset;

    // Si on est en haut de la page (ou en overscroll), on force le header visible
    if (offset <= 0) {
      if (!_headerVisible) setState(() => _headerVisible = true);
      _lastOffset = offset;
      return;
    }

    final delta = offset - _lastOffset;
    _lastOffset = offset;
    if (delta > 4 && _headerVisible) {
      setState(() => _headerVisible = false);
    } else if (delta < -4 && !_headerVisible) {
      setState(() => _headerVisible = true);
    }
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
    final topInset = MediaQuery.of(context).padding.top;
    final state = context.watch<HistoryBloc>().state;
    final filter = state is HistoryLoadSuccess ? state.filter : HistoryFilter.now();
    final filtersActive = _hasActiveFilters(filter);

    return Scaffold(
      backgroundColor: AppColors.quinoaCream,
      body: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          SafeArea(
            child: CustomScrollView(
              controller: _scrollController,
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
                SliverToBoxAdapter(child: HistoryStatsBar(state: state)),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                HistoryTxList(transactions: state.transactions),
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
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _headerVisible
                ? AppBackHeader(
                    onBack: () => Navigator.pop(context),
                    backLabel: HistoryStrings.backLabel,
                    title: HistoryStrings.title,
                    subtitle: HistoryStrings.headerSubtitle,
                    trailing: _FilterButton(
                      active: filtersActive,
                      onTap: () => _openFilterSheet(context),
                    ),
                  )
                : SizedBox(height: topInset),
          ),
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
              color: active ? Colors.white : AppColors.quinoaDark.withValues(alpha: 0.55),
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
