import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_bloc.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_state.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_bloc.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_event.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_state.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/dashboard_stats.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/payment_channel.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_hero.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_quick_actions.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_tx_list.dart";

/// Traduction exacte de DashboardView (Next.js)
class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    context.read<DashboardBloc>().add(DashboardStarted(month: now.month, year: now.year));
  }

  // Traduction de groupByDay du code JS
  Map<String, List<Transaction>> _groupByDay(List<Transaction> txs) {
    final Map<String, List<Transaction>> groups = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (final tx in txs) {
      final date = DateTime(tx.startedAt.year, tx.startedAt.month, tx.startedAt.day);
      String label;
      if (date == today) {
        label = "Aujourd'hui";
      } else if (date == yesterday) {
        label = "Hier";
      } else {
        label = DateFormat("dd MMMM", "fr_FR").format(date);
      }
      if (!groups.containsKey(label)) groups[label] = [];
      groups[label]!.add(tx);
    }
    return groups;
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final user = (authState is Authenticated) ? authState.user : null;
    
    // Calcul des initiales (Traduction de initials dans le JS)
    final initials = user?.fullName?.split(" ").map((n) => n[0]).take(2).join("").toUpperCase() ?? "?";

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        final bool loading = state is DashboardLoading;
        
        // Extraction robuste avec promotion de type
        final List<PaymentChannel> paymentChannels;
        final DashboardStats? stats;
        final List<Transaction> transactions;

        if (state is DashboardLoadSuccess) {
          paymentChannels = state.channels;
          stats = state.stats;
          transactions = state.transactions;
        } else {
          paymentChannels = [];
          stats = null;
          transactions = [];
        }

        final groups = _groupByDay(transactions);

        return RefreshIndicator(
          onRefresh: () async {
            final now = DateTime.now();
            context.read<DashboardBloc>().add(DashboardRefreshRequested(month: now.month, year: now.year));
          },
          displacement: 100,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 120), // Espace pour la bottom nav
            child: Column(
              children: [
                // DashboardHero (Passage des mêmes props que le JS)
                DashboardHero(
                  displayName: user?.fullName ?? "",
                  initials: initials,
                  totalReceived: stats?.totalReceived ?? 0,
                  totalSent: stats?.totalSent ?? 0,
                  channels: paymentChannels,
                  onPeriodClick: () => _showPeriodSheet(context),
                  onChannelSelect: (channel) => _showChannelSheet(context, channel),
                ),

                const DashboardQuickActions(),

                // Section Transactions Récentes (Style px-5 mt-6)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Transactions récentes",
                            style: TextStyle(
                              color: KinoaColors.stone900,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          _VoirToutBtn(),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // DashboardTxList (Passage des groupes comme le JS)
                      DashboardTxList(groups: groups, isLoading: loading),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showPeriodSheet(BuildContext context) {
    // Implémentation future du PeriodSheet
  }

  void _showChannelSheet(BuildContext context, dynamic channel) {
    // Implémentation future du ChannelSheet
  }
}

class _VoirToutBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F2E9),
          borderRadius: BorderRadius.circular(100),
        ),
        child: const Text(
          "Voir tout",
          style: TextStyle(
            color: Color(0xFFC8964A),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
