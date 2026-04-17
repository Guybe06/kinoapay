import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";

/// Écran d'accueil — placeholder, en reconstruction.
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
    return const Center(
      child: Text(
        "Dashboard",
        style: TextStyle(
          color: AppColors.quinoaDark,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
