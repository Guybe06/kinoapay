import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/history/application/bloc/history_bloc.dart";
import "package:kinoapay_app/features/history/application/bloc/history_event.dart";
import "package:kinoapay_app/features/history/application/bloc/history_state.dart";
import "package:kinoapay_app/features/history/domain/history_strings.dart";
import "package:kinoapay_app/features/history/presentation/widgets/history_filter_bar.dart";
import "package:kinoapay_app/core/navigation/presentation/widgets/app_back_header.dart";
import "package:kinoapay_app/features/history/presentation/widgets/history_stats_bar.dart";
import "package:kinoapay_app/features/history/presentation/widgets/history_tx_list.dart";

/// Écran Historique — orchestre header, filtres, stats et liste de transactions.
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.quinoaCream,
      body: BlocBuilder<HistoryBloc, HistoryState>(
        builder: (context, state) => CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: AppBackHeader(
                onBack: () => Navigator.pop(context),
                backLabel: HistoryStrings.backLabel,
                title: HistoryStrings.title,
                subtitle: HistoryStrings.headerSubtitle,
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
    );
  }
}
