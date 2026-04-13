import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_bloc.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_state.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_bloc.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_event.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_state.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/dashboard_stats.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_hero.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_recent_contacts.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_stats_card.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_tx_list.dart";

class DashboardView extends StatefulWidget {
  /// Appelé quand l'utilisateur tape ENVOYER — navigue vers l'onglet Send.
  final VoidCallback? onNavigateToSend;
  /// Appelé quand l'utilisateur tape DEMANDER — navigue vers la page request.
  final VoidCallback? onNavigateToRequest;

  const DashboardView({
    super.key,
    this.onNavigateToSend,
    this.onNavigateToRequest,
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
          color: KinoaColors.quinoaGold,
          backgroundColor: Colors.white,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(
              top: topInset + 56,
              bottom: MediaQuery.of(context).padding.bottom + 64 + 32 + 72,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── 1. Greeting ───────────────────────────────────────────
                _GreetingSection(firstName: firstName),

                const SizedBox(height: 8),

                // ── 2. Chip période ───────────────────────────────────────
                DashboardHero(onPeriodTap: () {}),

                const SizedBox(height: 16),

                // ── 3. Stats mensuelles ───────────────────────────────────
                if (stats != null) ...[
                  DashboardStatsCard(stats: stats),
                  const SizedBox(height: 16),
                ],

                // ── 4. Actions principales ────────────────────────────────
                _ActionButtons(
                  onSend: widget.onNavigateToSend ?? () {},
                  onRequest: widget.onNavigateToRequest ?? () {},
                ),

                const SizedBox(height: 20),

                // ── 5. Card promo ─────────────────────────────────────────
                const _PromoCard(),

                const SizedBox(height: 16),

                // ── 6. Contacts fréquents ─────────────────────────────────
                DashboardRecentContacts(
                  transactions: transactions,
                  onAdd: () {},
                ),

                const SizedBox(height: 28),

                // ── 7. Transactions récentes ──────────────────────────────
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
                              color: KinoaColors.quinoaDark.withValues(alpha: 0.85),
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.4,
                            ),
                          ),
                          _VoirToutBtn(),
                        ],
                      ),
                      const SizedBox(height: 14),
                      DashboardTxList(transactions: recent, isLoading: loading),
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

// ── Boutons d'action ──────────────────────────────────────────────────────────

class _ActionButtons extends StatelessWidget {
  final VoidCallback onSend;
  final VoidCallback onRequest;
  const _ActionButtons({required this.onSend, required this.onRequest});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _ActionBtn(label: "ENVOYER",  icon: SolarIconsOutline.arrowRightUp,  onTap: onSend)),
          const SizedBox(width: 12),
          Expanded(child: _ActionBtn(label: "DEMANDER", icon: SolarIconsOutline.arrowLeftDown, onTap: onRequest)),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _ActionBtn({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: KinoaColors.quinoaDark.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: KinoaColors.quinoaDark.withValues(alpha: 0.07)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: KinoaColors.quinoaDark),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: KinoaColors.quinoaDark,
                fontSize: 13,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Promo card ────────────────────────────────────────────────────────────────

class _PromoCard extends StatelessWidget {
  const _PromoCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: KinoaColors.accent,
          borderRadius: BorderRadius.circular(24),
        ),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Transférez partout,\nsans friction",
                    style: TextStyle(
                      color: KinoaColors.quinoaDark.withValues(alpha: 0.88),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Envoyez et recevez de l'argent en quelques secondes, où que vous soyez.",
                    style: TextStyle(
                      color: KinoaColors.quinoaDark.withValues(alpha: 0.55),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: KinoaColors.quinoaDark.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                SolarIconsOutline.plain,
                size: 20,
                color: KinoaColors.quinoaDark.withValues(alpha: 0.70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Greeting ──────────────────────────────────────────────────────────────────

class _GreetingSection extends StatelessWidget {
  final String firstName;
  const _GreetingSection({required this.firstName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bienvenue,",
            style: TextStyle(
              color: KinoaColors.quinoaWarmGray.withValues(alpha: 0.75),
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            firstName.isNotEmpty ? firstName : "—",
            style: const TextStyle(
              color: KinoaColors.quinoaDark,
              fontSize: 32,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Voir tout ─────────────────────────────────────────────────────────────────

class _VoirToutBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
        decoration: BoxDecoration(
          color: KinoaColors.quinoaDark.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: KinoaColors.quinoaDark.withValues(alpha: 0.08)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Voir tout",
              style: TextStyle(
                color: KinoaColors.quinoaWarmGray.withValues(alpha: 0.80),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 3),
            Icon(
              SolarIconsOutline.altArrowRight,
              size: 11,
              color: KinoaColors.quinoaWarmGray.withValues(alpha: 0.55),
            ),
          ],
        ),
      ),
    );
  }
}
