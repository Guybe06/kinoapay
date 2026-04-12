import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";

/// Représente une ligne de transaction individuelle dans la liste du tableau de bord.
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
    final currencyFormatter = NumberFormat.currency(symbol: tx.currency, decimalDigits: 0, locale: "fr_FR");

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: KinoaColors.stone200),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isReceived
                      ? KinoaColors.success.withValues(alpha: 0.1)
                      : KinoaColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  initials,
                  style: TextStyle(
                    color: isReceived ? KinoaColors.success : KinoaColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Positioned(
                top: -2,
                right: -2,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getStatusColor(tx.status),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: KinoaColors.stone900,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    _StatusBadge(status: tx.status),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: const TextStyle(
                        color: KinoaColors.stone500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${isReceived ? "+" : "−"}${currencyFormatter.format(tx.amount).replaceAll(tx.currency, "").trim()} ${tx.currency}",
                style: TextStyle(
                  color: isReceived ? KinoaColors.success : KinoaColors.stone900,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (!isReceived)
                const Text(
                  "envoyé",
                  style: TextStyle(
                    color: KinoaColors.stone500,
                    fontSize: 10,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case "COMPLETED":
        return const Color(0xFF16A34A);
      case "FAILED":
        return const Color(0xFFDC3545);
      case "PENDING":
        return const Color(0xFFD97706);
      case "ROUTING":
        return const Color(0xFF3B82F6);
      default:
        return const Color(0xFF3B82F6);
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> meta = _getStatusMeta(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: meta["color"].withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        meta["label"],
        style: TextStyle(
          color: meta["color"],
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Map<String, dynamic> _getStatusMeta(String status) {
    switch (status.toUpperCase()) {
      case "COMPLETED":
        return {"label": "Complété", "color": const Color(0xFF16A34A)};
      case "FAILED":
        return {"label": "Échoué", "color": const Color(0xFFDC3545)};
      case "PENDING":
        return {"label": "En attente", "color": const Color(0xFFD97706)};
      case "ROUTING":
        return {"label": "En cours", "color": const Color(0xFF3B82F6)};
      default:
        return {"label": "En cours", "color": const Color(0xFF3B82F6)};
    }
  }
}
