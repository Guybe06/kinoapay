import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";
import "package:kinoapay_app/features/history/domain/history_strings.dart";
import "package:kinoapay_app/features/history/presentation/widgets/history_tx_detail_sheet.dart";

/// Ligne de transaction épurée — icône directionnelle, nom, route canal, montant et statut.
class HistoryTxRow extends StatelessWidget {
  final Transaction tx;

  const HistoryTxRow({super.key, required this.tx});

  @override
  Widget build(BuildContext context) {
    final isSent = tx.direction == "sent";
    final isFailed = tx.status == "FAILED";
    final isPending = tx.status == "PENDING" || tx.status == "PROCESSING";
    final fmt = NumberFormat("#,###", "fr_FR");
    final timeFmt = DateFormat("HH:mm", "fr_FR");
    final name = isSent
        ? (tx.receiverName ?? tx.receiverIdentifier)
        : (tx.senderName ?? tx.receiverIdentifier);
    final amountColor = isFailed
        ? AppColors.quinoaDark.withValues(alpha: 0.30)
        : isSent
            ? AppColors.quinoaDark
            : AppColors.accentDark;
    final sign = isSent ? "−" : "+";

    return InkWell(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => HistoryTxDetailSheet(tx: tx),
      ),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            _DirectionIcon(isSent: isSent, status: tx.status),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: AppColors.quinoaDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "${tx.sourceChannel} → ${tx.destinationChannel}",
                        style: TextStyle(
                          color: AppColors.quinoaDark.withValues(alpha: 0.35),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Text(
                          "·",
                          style: TextStyle(
                            color: AppColors.quinoaDark.withValues(alpha: 0.18),
                            fontSize: 11,
                          ),
                        ),
                      ),
                      Text(
                        timeFmt.format(tx.startedAt),
                        style: TextStyle(
                          color: AppColors.quinoaDark.withValues(alpha: 0.25),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "$sign ${fmt.format(tx.amount)} XAF",
                  style: TextStyle(
                    color: amountColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                ),
                if (isPending || isFailed) ...[
                  const SizedBox(height: 4),
                  _StatusPill(status: tx.status),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Icône carrée arrondie indiquant la direction et le statut de la transaction.
class _DirectionIcon extends StatelessWidget {
  final bool isSent;
  final String status;

  const _DirectionIcon({required this.isSent, required this.status});

  @override
  Widget build(BuildContext context) {
    final isFailed = status == "FAILED";
    final isPending = status == "PENDING" || status == "PROCESSING";

    final Color bg;
    final Color iconColor;
    final IconData icon;

    if (isFailed) {
      bg = AppColors.quinoaRed.withValues(alpha: 0.07);
      iconColor = AppColors.quinoaRed.withValues(alpha: 0.55);
      icon = Icons.close_rounded;
    } else if (isPending) {
      bg = AppColors.warning.withValues(alpha: 0.08);
      iconColor = AppColors.warning;
      icon = Icons.schedule_rounded;
    } else if (isSent) {
      bg = AppColors.quinoaDark.withValues(alpha: 0.06);
      iconColor = AppColors.quinoaDark.withValues(alpha: 0.50);
      icon = Icons.arrow_upward_rounded;
    } else {
      bg = AppColors.success.withValues(alpha: 0.08);
      iconColor = AppColors.success;
      icon = Icons.arrow_downward_rounded;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, size: 17, color: iconColor),
    );
  }
}

/// Petit badge de statut non-complété affiché sous le montant.
class _StatusPill extends StatelessWidget {
  final String status;

  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final isPending = status == "PENDING" || status == "PROCESSING";
    final color = isPending ? AppColors.warning : AppColors.quinoaRed;
    final label = isPending
        ? HistoryStrings.sheetStatusPending
        : HistoryStrings.sheetStatusFailed;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
