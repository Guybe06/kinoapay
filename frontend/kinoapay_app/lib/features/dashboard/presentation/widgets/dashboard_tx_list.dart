import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_tx_row.dart";

/// Liste des transactions groupées (Traduction de dashboard-tx-list.tsx)
class DashboardTxList extends StatelessWidget {
  final Map<String, List<Transaction>> groups;
  final bool isLoading;

  const DashboardTxList({
    super.key,
    required this.groups,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const _LoadingSkeleton();
    if (groups.isEmpty) return const _EmptyState();

    return Column(
      children: groups.entries.map((entry) {
        return _TxGroup(label: entry.key, items: entry.value);
      }).toList(),
    );
  }
}

class _TxGroup extends StatelessWidget {
  final String label;
  final List<Transaction> items;

  const _TxGroup({required this.label, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.3),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ...items.map((tx) => DashboardTxRow(tx: tx)),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _LoadingSkeleton extends StatelessWidget {
  const _LoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (index) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: KinoaColors.stone900,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
        ),
      )),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(CupertinoIcons.time, size: 32, color: KinoaColors.stone300),
          const SizedBox(height: 16),
          const Text(
            "Aucune transaction récente",
            style: TextStyle(color: KinoaColors.stone400, fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
