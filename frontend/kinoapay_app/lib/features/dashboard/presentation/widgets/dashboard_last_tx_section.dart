import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/dashboard_strings.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_home_widgets.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_tx_list.dart";

/// Titre « Dernières transactions » + lien voir tout + liste.
class DashboardLastTxSection extends StatelessWidget {
  final List<Transaction> transactions;
  final VoidCallback onSeeAll;

  const DashboardLastTxSection({
    super.key,
    required this.transactions,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DashboardStrings.lastTx,
                style: TextStyle(
                  color: AppColors.quinoaDark.withValues(alpha: 0.85),
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
              DashboardVoirToutLink(onTap: onSeeAll),
            ],
          ),
          const SizedBox(height: 16),
          DashboardTxList(transactions: transactions),
        ],
      ),
    );
  }
}
