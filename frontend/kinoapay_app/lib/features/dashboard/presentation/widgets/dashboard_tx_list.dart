import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_tx_row.dart";

class DashboardTxList extends StatelessWidget {
  final List<Transaction> transactions;
  final bool isLoading;

  const DashboardTxList({
    super.key,
    required this.transactions,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const _LoadingSkeleton();
    if (transactions.isEmpty) return const _EmptyState();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: KinoaColors.quinoaDark.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: KinoaColors.quinoaDark.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: List.generate(transactions.length, (index) {
          final tx = transactions[index];
          final bool isLast = index == transactions.length - 1;

          return Column(
            children: [
              DashboardTxRow(tx: tx),
              if (!isLast)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: KinoaColors.quinoaDark.withValues(alpha: 0.04),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}

// ── Skeleton ──────────────────────────────────────────────────────────────────

class _LoadingSkeleton extends StatelessWidget {
  const _LoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        5,
        (i) => Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Container(
            height: 74,
            decoration: BoxDecoration(
              color: KinoaColors.quinoaDark.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: KinoaColors.quinoaDark.withValues(alpha: 0.06)),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Empty ─────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(
            SolarIconsOutline.history,
            size: 30,
            color: KinoaColors.quinoaWarmGray.withValues(alpha: 0.40),
          ),
          const SizedBox(height: 12),
          Text(
            "Aucune transaction récente",
            style: TextStyle(
              color: KinoaColors.quinoaWarmGray.withValues(alpha: 0.55),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
