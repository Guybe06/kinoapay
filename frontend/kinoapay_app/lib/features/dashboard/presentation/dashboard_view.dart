import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_bloc.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_state.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_bloc.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_event.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_state.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_hero.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_quick_actions.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_tx_list.dart";

/// Vue principale du tableau de bord.
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
    context.read<DashboardBloc>().add(
          DashboardStarted(month: now.month, year: now.year),
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final String displayName = (authState is Authenticated)
        ? (authState.user.fullName ?? "Utilisateur")
        : "Utilisateur";

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            final now = DateTime.now();
            context.read<DashboardBloc>().add(
                  DashboardRefreshRequested(month: now.month, year: now.year),
                );
          },
          color: KinoaColors.stone900,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                if (state is DashboardLoadSuccess)
                  DashboardHero(
                    displayName: displayName,
                    totalSent: state.stats.totalSent,
                    totalReceived: state.stats.totalReceived,
                    channels: state.channels,
                    onPeriodClick: () {},
                  )
                else
                  DashboardHero(
                    displayName: displayName,
                    totalSent: 0,
                    totalReceived: 0,
                    channels: const [],
                    onPeriodClick: () {},
                  ),
                const DashboardQuickActions(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Transactions récentes",
                            style: TextStyle(
                              color: KinoaColors.stone900,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              backgroundColor: KinoaColors.stone100,
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            child: const Text(
                              "Voir tout",
                              style: TextStyle(
                                color: KinoaColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (state is DashboardLoadSuccess)
                        DashboardTxList(transactions: state.transactions)
                      else if (state is DashboardLoading)
                        const DashboardTxList(transactions: [], isLoading: true)
                      else if (state is DashboardLoadFailure)
                        Center(child: Text(state.message))
                      else
                        const DashboardTxList(transactions: []),
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
}
