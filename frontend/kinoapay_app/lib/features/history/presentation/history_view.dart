import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/history/application/bloc/history_bloc.dart";
import "package:kinoapay_app/features/history/application/bloc/history_event.dart";
import "package:kinoapay_app/features/history/application/bloc/history_state.dart";
import "package:kinoapay_app/features/history/domain/history_strings.dart";
import "package:kinoapay_app/features/history/presentation/widgets/history_filter_bar.dart";
import "package:kinoapay_app/core/navigation/presentation/widgets/app_back_header.dart";
import "package:kinoapay_app/core/widgets/app_page_title.dart";
import "package:kinoapay_app/features/history/presentation/widgets/history_stats_bar.dart";
import "package:kinoapay_app/features/history/presentation/widgets/history_tx_list.dart";

/// Écran Historique — même comportement de header scroll-hide que Plus et Dashboard.
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
    final delta = offset - _lastOffset;
    _lastOffset = offset;
    if (delta > 4 && _headerVisible) {
      setState(() => _headerVisible = false);
    } else if (delta < -4 && !_headerVisible) {
      setState(() => _headerVisible = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColors.quinoaCream,
      body: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          BlocBuilder<HistoryBloc, HistoryState>(
            builder: (context, state) => CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: SizedBox(height: topInset + 72)),
                const SliverToBoxAdapter(
                  child: AppPageTitle(
                    title: HistoryStrings.pageTitle,
                    subtitle: HistoryStrings.pageSubtitle,
                  ),
                ),
                if (state is HistoryLoadSuccess) ...[
                  SliverToBoxAdapter(
                    child: HistoryFilterBar(
                      filter: state.filter,
                      onChanged: (f) =>
                          context.read<HistoryBloc>().add(HistoryFilterChanged(f)),
                    ),
                  ),
                  SliverToBoxAdapter(child: HistoryStatsBar(state: state)),
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
                  )
                : SizedBox(height: topInset),
          ),
        ],
      ),
    );
  }
}
