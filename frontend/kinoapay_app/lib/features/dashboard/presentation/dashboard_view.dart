import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/core/widgets/app_snack_bar.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_bloc.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_event.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_state.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_content.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_skeleton.dart";

/// Point d'entrée de la feature Dashboard.
/// Orchestre les états BLoC et délègue le rendu à [DashboardContent].
class DashboardView extends StatelessWidget {
  final String firstName;
  final bool kycVerified;
  final VoidCallback? onNavigateToSend;
  final VoidCallback? onNavigateToRequest;
  final VoidCallback? onNavigateToHistory;

  const DashboardView({
    super.key,
    required this.firstName,
    this.kycVerified = false,
    this.onNavigateToSend,
    this.onNavigateToRequest,
    this.onNavigateToHistory,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardBloc, DashboardState>(
      listener: (context, state) {
        if (state is DashboardLoadFailure) {
          AppSnackBar.showError(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is DashboardLoading) return const DashboardSkeleton();

        if (state is DashboardLoadSuccess) {
          return DashboardContent(
            firstName: firstName,
            kycVerified: kycVerified,
            stats: state.stats,
            transactions: state.transactions,
            channels: state.channels,
            isStatsRefreshing: state.isStatsRefreshing,
            onNavigateToSend: onNavigateToSend,
            onNavigateToRequest: onNavigateToRequest,
            onNavigateToHistory: onNavigateToHistory,
          );
        }

        final now = DateTime.now();
        context.read<DashboardBloc>().add(
          DashboardStarted(month: now.month, year: now.year),
        );
        return const DashboardSkeleton();
      },
    );
  }
}
