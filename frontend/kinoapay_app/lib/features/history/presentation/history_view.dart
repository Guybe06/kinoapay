import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/core/widgets/staggered_entrance.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_bloc.dart";
import "package:kinoapay_app/features/dashboard/application/bloc/dashboard_state.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";
import "package:kinoapay_app/features/history/domain/history_strings.dart";

/// Écran Historique : liste de transactions groupées par date, tap vers receipt.
class HistoryView extends StatelessWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;

    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        final List<Transaction> transactions = state is DashboardLoadSuccess ? state.transactions : [];

        return SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, topInset + 80, 20, 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: transactions.isEmpty
                ? [KinoaEntrance(index: 0, child: _buildEmpty())]
                : _buildGroupedList(transactions),
          ),
        );
      },
    );
  }

  List<Widget> _buildGroupedList(List<Transaction> transactions) {
    final grouped = _groupByDate(transactions);
    final widgets = <Widget>[];
    int entranceIdx = 0;

    for (final entry in grouped.entries) {
      widgets.add(KinoaEntrance(
        index: entranceIdx++,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10, left: 4),
          child: Text(
            entry.key,
            style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.4), fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 0.5),
          ),
        ),
      ));

      widgets.add(KinoaEntrance(
        index: entranceIdx++,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: KinoaColors.quinoaDark.withValues(alpha: 0.06)),
          ),
          child: Column(
            children: [
              for (int i = 0; i < entry.value.length; i++) ...[
                if (i > 0) Divider(height: 1, indent: 60, endIndent: 16, color: KinoaColors.quinoaDark.withValues(alpha: 0.05)),
                _TxTile(tx: entry.value[i]),
              ],
            ],
          ),
        ),
      ));
    }
    return widgets;
  }

  Map<String, List<Transaction>> _groupByDate(List<Transaction> txs) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final Map<String, List<Transaction>> groups = {};

    for (final tx in txs) {
      final txDay = DateTime(tx.startedAt.year, tx.startedAt.month, tx.startedAt.day);
      final String label;
      if (txDay == today) {
        label = HistoryStrings.today.toUpperCase();
      } else if (txDay == yesterday) {
        label = HistoryStrings.yesterday.toUpperCase();
      } else {
        label = DateFormat("d MMMM yyyy", "fr_FR").format(tx.startedAt).toUpperCase();
      }
      groups.putIfAbsent(label, () => []).add(tx);
    }
    return groups;
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 80),
          Icon(Icons.receipt_long_rounded, size: 48, color: KinoaColors.quinoaDark.withValues(alpha: 0.2)),
          const SizedBox(height: 12),
          Text(HistoryStrings.empty, style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.4), fontSize: 14, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _TxTile extends StatelessWidget {
  final Transaction tx;
  const _TxTile({required this.tx});

  @override
  Widget build(BuildContext context) {
    final isOut = tx.direction == "outgoing";
    final sign = isOut ? "−" : "+";
    final color = isOut ? KinoaColors.quinoaDark : KinoaColors.accentDark;
    final name = isOut ? (tx.receiverName ?? tx.receiverIdentifier) : (tx.senderName ?? "Inconnu");
    final time = DateFormat("HH:mm", "fr_FR").format(tx.startedAt);
    final fmt = NumberFormat("#,###", "fr_FR");

    return InkWell(
      onTap: () => Navigator.pushNamed(context, KinoaRoutes.receipt, arguments: tx),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: (isOut ? KinoaColors.quinoaDark : KinoaColors.accentDark).withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isOut ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                size: 16,
                color: isOut ? KinoaColors.quinoaDark : KinoaColors.accentDark,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(color: KinoaColors.quinoaDark, fontSize: 14, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(time, style: TextStyle(color: KinoaColors.quinoaDark.withValues(alpha: 0.35), fontSize: 11)),
                ],
              ),
            ),
            Text(
              "$sign ${fmt.format(tx.amount)} ${tx.currency}",
              style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}
