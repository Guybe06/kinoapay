import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_bloc.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_state.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_bloc.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_event.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_state.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/dashboard_stats.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_recent_contacts.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_stats_card.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_tx_list.dart";

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
      builder: (context) => const _PromoDetailSheet(),
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
                // Lumières diffuses en arrière-plan (BOOSTÉES)
                Positioned(
                  top: 50,
                  right: -80,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.accent.withValues(alpha: 0.25),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 200,
                  left: -100,
                  child: Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.accent.withValues(alpha: 0.15),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _GreetingSection(firstName: firstName),
                    const SizedBox(height: 16),
                    if (stats != null) ...[
                      DashboardStatsCard(stats: stats),
                      const SizedBox(height: 16),
                    ],
                    _ActionButtons(
                      onSend: widget.onNavigateToSend ?? () {},
                      onRequest: widget.onNavigateToRequest ?? () {},
                    ),
                    const SizedBox(height: 20),
                    _PromoCard(onTap: _showPromoDetail),
                    const SizedBox(height: 16),
                    DashboardRecentContacts(
                      transactions: transactions,
                      onAdd: () => Navigator.pushNamed(context, AppRoutes.contacts),
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
                                  color: AppColors.quinoaDark.withValues(alpha: 0.85),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.4,
                                ),
                              ),
                              _VoirToutBtn(onTap: widget.onNavigateToHistory ?? () {}),
                            ],
                          ),
                          const SizedBox(height: 14),
                          DashboardTxList(transactions: recent, isLoading: loading),
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
          Expanded(child: _ActionBtn(label: "DEMANDER", icon: SolarIconsOutline.cardReceive, onTap: onRequest)),
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
          color: AppColors.quinoaDark.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: AppColors.quinoaDark.withValues(alpha: 0.07)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: AppColors.quinoaDark),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.quinoaDark,
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
  final VoidCallback onTap;
  const _PromoCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFF141414),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -50,
              top: -50,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.accent.withValues(alpha: 0.25),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Transférez partout,\nsans friction",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.6,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Envoyez et recevez de l'argent en quelques secondes.",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 24),
                        GestureDetector(
                          onTap: onTap,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.accent.withValues(alpha: 0.4),
                                  blurRadius: 20,
                                  spreadRadius: -2,
                                ),
                              ],
                            ),
                            child: const Text(
                              "En savoir plus",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 4,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(22),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.accent.withValues(alpha: 0.06),
                          border: Border.all(color: AppColors.accent.withValues(alpha: 0.1)),
                        ),
                        child: const Icon(
                          SolarIconsOutline.plain,
                          size: 48,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  ),
                ],
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
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bienvenue,",
            style: TextStyle(
              color: AppColors.quinoaWarmGray.withValues(alpha: 0.75),
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            firstName.isNotEmpty ? firstName : "—",
            style: const TextStyle(
              color: AppColors.quinoaDark,
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
  final VoidCallback onTap;
  const _VoirToutBtn({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.quinoaDark.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: AppColors.quinoaDark.withValues(alpha: 0.08)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Voir tout",
              style: TextStyle(
                color: AppColors.quinoaWarmGray.withValues(alpha: 0.80),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 3),
            Icon(
              SolarIconsOutline.altArrowRight,
              size: 11,
              color: AppColors.quinoaWarmGray.withValues(alpha: 0.55),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Promo Detail Sheet ────────────────────────────────────────────────────────

class _PromoDetailSheet extends StatelessWidget {
  const _PromoDetailSheet();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Color(0xFF141414),
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -100,
                right: -50,
                child: Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.accent.withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  const SizedBox(height: 12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                      children: [
                        const Text(
                          "Transférez partout,\nsans friction",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1.0,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _InfoSection(
                          icon: SolarIconsOutline.link,
                          title: "Le lien entre tous vos comptes",
                          description: "kinoaPay fait le pont entre vos comptes Mobile Money et vos banques. Vous n'avez pas besoin de créer un nouveau compte ou d'y stocker de l'argent : nous faisons simplement en sorte que vos comptes se parlent enfin.",
                        ),
                        const SizedBox(height: 32),
                        _InfoSection(
                          icon: SolarIconsOutline.userId,
                          title: "Une identité unique pour tout recevoir",
                          description: "Avec votre KinoaID, recevoir de l'argent devient un jeu d'enfant. Ne donnez plus vos numéros de téléphone ou vos coordonnées bancaires à tout le monde. Un seul identifiant suffit pour recevoir vos fonds directement là où vous le souhaitez.",
                        ),
                        const SizedBox(height: 32),
                        _InfoSection(
                          icon: SolarIconsOutline.safeCircle,
                          title: "Un reçu numérique qui ne ment jamais",
                          description: "Chaque transaction est protégée par une preuve numérique infalsifiable. C'est une garantie que personne ne peut contester : votre argent est suivi à la trace et arrive toujours à bon port, avec une transparence totale.",
                        ),
                        const SizedBox(height: 32),
                        _InfoSection(
                          icon: SolarIconsOutline.bolt,
                          title: "L'intelligence qui évite les attentes",
                          description: "Notre système surveille la santé des réseaux en temps réel. Si un opérateur ralentit ou tombe en panne, kinoaPay le voit instantanément et trouve automatiquement un chemin plus rapide pour que votre transfert reste immédiat.",
                        ),
                        const SizedBox(height: 48),
                        Text(
                          "kinoaPay ne change pas vos habitudes, il les simplifie en connectant vos moyens de paiement préférés sous une protection universelle.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _InfoSection extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _InfoSection({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppColors.accent, size: 28),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                description,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
