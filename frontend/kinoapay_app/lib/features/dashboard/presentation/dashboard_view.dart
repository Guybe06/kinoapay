import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_bloc.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_state.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_bloc.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_event.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_state.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/dashboard_stats.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_home_widgets.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_promo_detail_sheet.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_promo_widgets.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_recent_contacts.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_stats_card.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_tx_list.dart";

/// Écran d’accueil : statistiques, raccourcis, promo et aperçu des transactions.
class DashboardView extends StatefulWidget {
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
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    context.read<DashboardBloc>().add(
      DashboardStarted(month: now.month, year: now.year),
    );
  }

  void _showPromoDetail() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const DashboardPromoDetailSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    final authState = context.watch<AuthBloc>().state;
    final user = (authState is Authenticated) ? authState.user : null;
    final firstName = user?.fullName?.split(" ").first ?? "";

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        final bool loading = state is DashboardLoading;
        final DashboardStats? stats;
        final List<Transaction> transactions;

        if (state is DashboardLoadSuccess) {
          stats = state.stats;
          transactions = state.transactions;
        } else {
          stats = null;
          transactions = [];
        }

        final recent = transactions.take(5).toList();

        return RefreshIndicator(
          onRefresh: () async {
            final now = DateTime.now();
            context.read<DashboardBloc>().add(
              DashboardRefreshRequested(month: now.month, year: now.year),
            );
          },
          displacement: 100,
          color: AppColors.quinoaGold,
          backgroundColor: Colors.white,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(
              top: topInset,
              bottom: MediaQuery.of(context).padding.bottom + 64 + 32 + 72,
            ),
            child: Stack(
              children: [
                const DashboardAmbientBackground(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DashboardGreetingSection(firstName: firstName),
                    const SizedBox(height: 16),
                    if (stats != null) ...[
                      DashboardStatsCard(stats: stats),
                      const SizedBox(height: 16),
                    ],
                    DashboardActionButtons(
                      onSend: widget.onNavigateToSend ?? () {},
                      onRequest: widget.onNavigateToRequest ?? () {},
                    ),
                    const SizedBox(height: 20),
                    DashboardPromoCard(onTap: _showPromoDetail),
                    const SizedBox(height: 16),
                    DashboardRecentContacts(
                      transactions: transactions,
                      onAdd: () =>
                          Navigator.pushNamed(context, AppRoutes.contacts),
                    ),
                    const SizedBox(height: 28),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Dernières transactions",
                                style: TextStyle(
                                  color: AppColors.quinoaDark.withValues(
                                    alpha: 0.85,
                                  ),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              DashboardVoirToutLink(
                                onTap: widget.onNavigateToHistory ?? () {},
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          DashboardTxList(
                            transactions: recent,
                            isLoading: loading,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
