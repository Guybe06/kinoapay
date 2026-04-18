import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/navigation/presentation/widgets/app_header.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_bloc.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_event.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_state.dart";
import "package:kinoapay_app/features/dashboard/domain/dashboard_strings.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/dashboard_stats.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_home_widgets.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_promo_detail_sheet.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_promo_widgets.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_recent_contacts.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_stats_card.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_tx_list.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_tx_list_placeholders.dart";

class DashboardView extends StatelessWidget {
  final VoidCallback? onNavigateToSend;
  final VoidCallback? onNavigateToRequest;
  final VoidCallback? onNavigateToHistory;

  const DashboardView({
    super.key,
    this.onNavigateToSend,
    this.onNavigateToRequest,
    this.onNavigateToHistory,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, state) {
        if (state is DashboardLoadFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is DashboardLoading) {
          return const _DashboardSkeleton();
        }
        if (state is DashboardLoadSuccess) {
          return _DashboardContent(
            stats: state.stats,
            transactions: state.transactions,
            channels: state.channels,
            onNavigateToSend: onNavigateToSend,
            onNavigateToRequest: onNavigateToRequest,
            onNavigateToHistory: onNavigateToHistory,
          );
        }
        final now = DateTime.now();
        context.read<DashboardBloc>().add(
          DashboardStarted(month: now.month, year: now.year),
        );
        return const _DashboardSkeleton();
      },
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final DashboardStats stats;
  final List<Transaction> transactions;
  final List<dynamic> channels;
  final VoidCallback? onNavigateToSend;
  final VoidCallback? onNavigateToRequest;
  final VoidCallback? onNavigateToHistory;

  const _DashboardContent({
    required this.stats,
    required this.transactions,
    required this.channels,
    this.onNavigateToSend,
    this.onNavigateToRequest,
    this.onNavigateToHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.quinoaCream,
      appBar: const AppHeader(),
      body: Stack(
        children: [
          const DashboardAmbientBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  const DashboardGreetingSection(firstName: "Jean"),
                  const SizedBox(height: 20),
                  DashboardStatsCard(stats: stats),
                  const SizedBox(height: 20),
                  DashboardActionButtons(
                    onSend: onNavigateToSend ?? () {},
                    onRequest: onNavigateToRequest ?? () {},
                  ),
                  const SizedBox(height: 20),
                  DashboardRecentContacts(
                    transactions: transactions,
                    onAdd: () {},
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DashboardStrings.lastTx,
                          style: TextStyle(
                            color: AppColors.quinoaDark.withValues(alpha: 0.85),
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                          ),
                        ),
                        DashboardVoirToutLink(
                          onTap: onNavigateToHistory ?? () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: DashboardTxList(transactions: transactions),
                  ),
                  const SizedBox(height: 24),
                  DashboardPromoCard(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const DashboardPromoDetailSheet(),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardSkeleton extends StatelessWidget {
  const _DashboardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.quinoaCream,
      appBar: const AppHeader(),
      body: Stack(
        children: [
          const DashboardAmbientBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const DashboardGreetingSection(firstName: ""),
                  const SizedBox(height: 24),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: AppColors.quinoaDark.withValues(alpha: 0.06),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  DashboardActionButtons(onSend: () {}, onRequest: () {}),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                        color: AppColors.quinoaDark,
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 130,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: AppColors.quinoaDark.withValues(alpha: 0.06),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      DashboardStrings.lastTx,
                      style: TextStyle(
                        color: AppColors.quinoaDark.withValues(alpha: 0.85),
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: DashboardTxListSkeleton(),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
