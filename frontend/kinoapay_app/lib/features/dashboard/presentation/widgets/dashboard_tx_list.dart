import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_tx_list_placeholders.dart";
import "package:kinoapay_app/features/history/presentation/widgets/history_tx_row.dart";

/// Liste des transactions récentes dans une carte blanche arrondie.
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
    if (isLoading) return const DashboardTxListSkeleton();
    if (transactions.isEmpty) return const DashboardTxListEmpty();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.quinoaDark.withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: AppColors.quinoaDark.withValues(alpha: 0.04),
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
              HistoryTxRow(tx: tx),
              if (!isLast)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.quinoaDark.withValues(alpha: 0.04),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}
