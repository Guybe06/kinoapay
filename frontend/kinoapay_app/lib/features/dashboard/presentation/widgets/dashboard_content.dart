import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/navigation/presentation/widgets/app_header.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_bloc.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_event.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/dashboard_stats.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/payment_channel.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_card_skeletons.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_channel_stats.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_channel_stats_skeleton.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_home_widgets.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_kyc_banner.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_last_tx_section.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_promo_detail_sheet.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_promo_widgets.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_recent_contacts.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_stats_card.dart";

/// Corps principal scrollable du tableau de bord.
/// Reçoit les données déjà chargées depuis [DashboardView].
class DashboardContent extends StatefulWidget {
  final String firstName;
  final bool kycVerified;
  final DashboardStats stats;
  final List<Transaction> transactions;
  final List<PaymentChannel> channels;
  final bool isStatsRefreshing;
  final VoidCallback? onNavigateToSend;
  final VoidCallback? onNavigateToRequest;
  final VoidCallback? onNavigateToHistory;

  const DashboardContent({
    super.key,
    required this.firstName,
    required this.kycVerified,
    required this.stats,
    required this.transactions,
    required this.channels,
    this.isStatsRefreshing = false,
    this.onNavigateToSend,
    this.onNavigateToRequest,
    this.onNavigateToHistory,
  });

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  final _scrollController = ScrollController();
  bool _headerVisible = true;
  double _lastOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
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

  Future<void> _onRefresh() async {
    final now = DateTime.now();
    context.read<DashboardBloc>().add(
      DashboardRefreshRequested(month: now.month, year: now.year),
    );
    await Future.delayed(const Duration(milliseconds: 800));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.quinoaCream,
      body: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          const DashboardAmbientBackground(),
          SafeArea(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppColors.quinoaGold,
              backgroundColor: Colors.white,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 100),
                child: _buildBody(context),
              ),
            ),
          ),
          _buildFloatingHeader(context),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 68),
        DashboardGreetingSection(firstName: widget.firstName),
        if (!widget.kycVerified) ...[
          const SizedBox(height: 12),
          const DashboardKycBanner(),
        ],
        const SizedBox(height: 20),
        IndexedStack(
          index: widget.isStatsRefreshing ? 0 : 1,
          children: [
            const DashboardStatsCardSkeleton(),
            DashboardStatsCard(stats: widget.stats),
          ],
        ),
        const SizedBox(height: 20),
        DashboardActionButtons(
          onSend: widget.onNavigateToSend ?? () {},
          onRequest: widget.onNavigateToRequest ?? () {},
        ),
        const SizedBox(height: 16),
        if (widget.isStatsRefreshing || widget.stats.channelStats.isNotEmpty) ...[
          widget.isStatsRefreshing
              ? const DashboardChannelStatsSkeleton()
              : DashboardChannelStats(stats: widget.stats.channelStats),
          const SizedBox(height: 20),
        ],
        DashboardPromoCard(
          onTap: () => showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => const DashboardPromoDetailSheet(),
          ),
        ),
        const SizedBox(height: 20),
        DashboardRecentContacts(transactions: widget.transactions, onAdd: () {}),
        const SizedBox(height: 24),
        DashboardLastTxSection(
          transactions: widget.transactions,
          onSeeAll: widget.onNavigateToHistory ?? () {},
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildFloatingHeader(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: _headerVisible
          ? const Material(
              color: AppColors.quinoaCream,
              elevation: 0,
              shadowColor: Colors.transparent,
              child: AppHeader(),
            )
          : SizedBox(height: topInset),
    );
  }
}
