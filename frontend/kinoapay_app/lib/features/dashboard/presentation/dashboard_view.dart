import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_bloc.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_event.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_state.dart";
import "package:kinoapay_app/features/dashboard/domain/dashboard_strings.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_home_widgets.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_quick_actions.dart";
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
        context.read<DashboardBloc>().add(DashboardDataRequested());
        return const _DashboardSkeleton();
      },
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final dynamic stats;
  final List<dynamic> transactions;
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
                  const DashboardGreetingSection(firstName: "Jean"),
                  const SizedBox(height: 24),
                  DashboardActionButtons(
                    onSend: onNavigateToSend ?? () {},
                    onRequest: onNavigateToRequest ?? () {},
                  ),
                  const SizedBox(height: 24),
                  DashboardStatsCard(stats: stats),
                  const SizedBox(height: 24),
                  DashboardRecentContacts(
                    transactions: transactions,
                    onAdd: () {},
                  ),
                  const SizedBox(height: 24),
                  DashboardQuickActions(),
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
                  DashboardActionButtons(onSend: () {}, onRequest: () {}),
                  const SizedBox(height: 24),
                  const DashboardStatsCardSkeleton(),
                  const SizedBox(height: 24),
                  const DashboardRecentContactsSkeleton(),
                  const SizedBox(height: 24),
                  const DashboardQuickActions(),
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

class _DashboardStatsCardSkeleton extends StatelessWidget {
  const _DashboardStatsCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.quinoaDark.withValues(alpha: 0.06)),
      ),
    );
  }
}

class _DashboardRecentContactsSkeleton extends StatelessWidget {
  const _DashboardRecentContactsSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
