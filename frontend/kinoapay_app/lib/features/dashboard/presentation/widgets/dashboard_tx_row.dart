import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";

class DashboardTxRow extends StatelessWidget {
  final Transaction tx;

  const DashboardTxRow({super.key, required this.tx});

  @override
  Widget build(BuildContext context) {
    final bool isReceived = tx.direction == "received";
    final String name = isReceived
        ? (tx.senderName ?? tx.receiverIdentifier)
        : (tx.receiverName ?? tx.receiverIdentifier);

    final String initials = name.isNotEmpty
        ? name.split(" ").map((n) => n[0]).take(2).join("").toUpperCase()
        : "?";

    final String time = DateFormat("HH:mm", "fr_FR").format(tx.startedAt);
    final currencyFormatter = NumberFormat.currency(symbol: "", decimalDigits: 0, locale: "fr_FR");

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: KinoaColors.stone900,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: KinoaColors.stone800,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              initials,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 16),
          
          // Détails
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          
          // Montant
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${isReceived ? "+" : "−"} ${currencyFormatter.format(tx.amount).trim()}",
                style: TextStyle(
                  color: isReceived ? KinoaColors.accent : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              _CompactStatus(status: tx.status),
            ],
          ),
        ],
      ),
    );
  }
}

class _CompactStatus extends StatelessWidget {
  final String status;
  const _CompactStatus({required this.status});

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = status.toUpperCase() == "COMPLETED";
    return Text(
      isCompleted ? "Réussi" : "En attente",
      style: TextStyle(
        color: isCompleted ? Colors.white24 : KinoaColors.accent.withValues(alpha: 0.7),
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
    );
  }
}
