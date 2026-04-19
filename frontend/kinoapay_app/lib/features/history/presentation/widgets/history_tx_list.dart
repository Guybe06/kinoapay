import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";
import "package:kinoapay_app/features/history/domain/history_strings.dart";
import "package:kinoapay_app/features/history/presentation/widgets/history_tx_row.dart";

/// Liste des transactions groupées par date — retourne plusieurs slivers.
///
/// Utilisation : placer directement dans un [CustomScrollView] via [buildSlivers].
class HistoryTxList extends StatelessWidget {
  final List<Transaction> transactions;

  const HistoryTxList({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const SliverFillRemaining(
        hasScrollBody: false,
        child: _EmptyState(),
      );
    }

    final grouped = _groupByDate(transactions);
    final items = <Widget>[];
    for (final entry in grouped.entries) {
      items.add(_DateLabel(label: entry.key));
      items.add(_TxGroup(transactions: entry.value));
    }
    items.add(const SizedBox(height: 120));

    return SliverList(
      delegate: SliverChildListDelegate(items),
    );
  }

  static Map<String, List<Transaction>> _groupByDate(List<Transaction> txs) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final grouped = <String, List<Transaction>>{};

    for (final tx in txs) {
      final txDay = DateTime(tx.startedAt.year, tx.startedAt.month, tx.startedAt.day);
      final String label;
      if (txDay == today) {
        label = HistoryStrings.today.toUpperCase();
      } else if (txDay == yesterday) {
        label = HistoryStrings.yesterday.toUpperCase();
      } else {
        final raw = DateFormat("d MMMM yyyy", "fr_FR").format(tx.startedAt);
        label = "${raw[0].toUpperCase()}${raw.substring(1)}".toUpperCase();
      }
      grouped.putIfAbsent(label, () => []).add(tx);
    }
    return grouped;
  }
}

class _DateLabel extends StatelessWidget {
  final String label;
  const _DateLabel({required this.label});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
    child: Text(
      label,
      style: TextStyle(
        color: AppColors.quinoaDark.withValues(alpha: 0.35),
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.8,
      ),
    ),
  );
}

class _TxGroup extends StatelessWidget {
  final List<Transaction> transactions;
  const _TxGroup({required this.transactions});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppColors.quinoaDark.withValues(alpha: 0.06)),
    ),
    child: Column(
      children: [
        for (var i = 0; i < transactions.length; i++) ...[
          if (i > 0)
            Divider(
              height: 1,
              indent: 60,
              endIndent: 16,
              color: AppColors.quinoaDark.withValues(alpha: 0.05),
            ),
          HistoryTxRow(tx: transactions[i]),
        ],
      ],
    ),
  );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        SolarIconsOutline.documentText,
        size: 52,
        color: AppColors.quinoaDark.withValues(alpha: 0.15),
      ),
      const SizedBox(height: 14),
      Text(
        HistoryStrings.empty,
        style: TextStyle(
          color: AppColors.quinoaDark.withValues(alpha: 0.45),
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 6),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Text(
          HistoryStrings.emptySubtitle,
          style: TextStyle(
            color: AppColors.quinoaDark.withValues(alpha: 0.25),
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    ],
  );
}
