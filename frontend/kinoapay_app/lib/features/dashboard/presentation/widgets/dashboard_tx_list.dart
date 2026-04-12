import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:lucide_icons/lucide_icons.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_tx_row.dart";

/// Liste des transactions récentes groupées par date.
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
    if (isLoading) {
      return const _LoadingSkeleton();
    }

    if (transactions.isEmpty) {
      return const _EmptyState();
    }

    final groups = _groupByDay(transactions);

    return Column(
      children: groups.entries.map((entry) {
        return _TxGroup(label: entry.key, items: entry.value);
      }).toList(),
    );
  }

  Map<String, List<Transaction>> _groupByDay(List<Transaction> txs) {
    final Map<String, List<Transaction>> groups = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    for (final tx in txs) {
      final date = DateTime(tx.startedAt.year, tx.startedAt.month, tx.startedAt.day);
      String label;

      if (date == today) {
        label = "Aujourd'hui";
      } else if (date == yesterday) {
        label = "Hier";
      } else {
        label = DateFormat("dd MMMM", "fr_FR").format(date);
      }

      if (!groups.containsKey(label)) {
        groups[label] = [];
      }
      groups[label]!.add(tx);
    }
    return groups;
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
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  color: KinoaColors.stone500,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(width: 8),
              const Expanded(child: Divider(color: KinoaColors.stone200, thickness: 1)),
            ],
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) => DashboardTxRow(tx: items[index]),
        ),
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
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: KinoaColors.stone100,
            borderRadius: BorderRadius.circular(20),
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: KinoaColors.stone200, style: BorderStyle.solid),
      ),
      child: Column(
        children: [
          Icon(LucideIcons.clock, size: 28, color: KinoaColors.stone300),
          const SizedBox(height: 12),
          const Text(
            "Aucune transaction ce mois",
            style: TextStyle(color: KinoaColors.stone500, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
