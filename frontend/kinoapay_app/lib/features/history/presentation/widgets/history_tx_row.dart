import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/utils/amount_formatter.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";
import "package:kinoapay_app/features/history/domain/history_strings.dart";
import "package:kinoapay_app/features/history/presentation/widgets/history_tx_detail_sheet.dart";

/// Ligne de transaction style terminal — dense, statut toujours visible, identifiant affiché.
class HistoryTxRow extends StatelessWidget {
  final Transaction tx;

  const HistoryTxRow({super.key, required this.tx});

  @override
  Widget build(BuildContext context) {
    final isSent = tx.direction == "sent";
    final isFailed = tx.status == "FAILED";
    final timeFmt = DateFormat("HH:mm", "fr_FR");
    final name = isSent
        ? (tx.receiverName ?? tx.receiverIdentifier)
        : (tx.senderName ?? tx.receiverIdentifier);
    final amountColor = isFailed
        ? AppColors.quinoaDark.withValues(alpha: 0.28)
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _DirectionIcon(isSent: isSent, status: tx.status),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            color: AppColors.quinoaDark,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.2,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "$sign ${AmountFormatter.format(tx.amount)} ${HistoryStrings.currency}",
                        style: TextStyle(
                          color: amountColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.4,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          tx.receiverIdentifier,
                          style: TextStyle(
                            color: AppColors.quinoaDark.withValues(alpha: 0.50),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _StatusDot(status: tx.status),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${tx.sourceChannel} → ${tx.destinationChannel}  ·  ${timeFmt.format(tx.startedAt)}",
                    style: TextStyle(
                      color: AppColors.quinoaDark.withValues(alpha: 0.25),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Icône directionnelle — carrée arrondie, couleur selon direction et statut.
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
      iconColor = AppColors.quinoaRed.withValues(alpha: 0.50);
      icon = Icons.close_rounded;
    } else if (isPending) {
      bg = AppColors.warning.withValues(alpha: 0.08);
      iconColor = AppColors.warning;
      icon = Icons.schedule_rounded;
    } else if (isSent) {
      bg = AppColors.quinoaDark.withValues(alpha: 0.05);
      iconColor = AppColors.quinoaDark.withValues(alpha: 0.45);
      icon = Icons.north_east_rounded;
    } else {
      bg = AppColors.success.withValues(alpha: 0.07);
      iconColor = AppColors.success;
      icon = Icons.south_west_rounded;
    }

    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 15, color: iconColor),
    );
  }
}

/// Point de statut coloré — toujours visible pour toutes les transactions.
class _StatusDot extends StatelessWidget {
  final String status;

  const _StatusDot({required this.status});

  Color get _color => switch (status) {
        "COMPLETED" => AppColors.success,
        "PENDING" || "PROCESSING" => AppColors.warning,
        _ => AppColors.quinoaRed,
      };

  String get _label => switch (status) {
        "COMPLETED" => HistoryStrings.sheetStatusCompleted,
        "PENDING" => HistoryStrings.sheetStatusPending,
        "PROCESSING" => HistoryStrings.sheetStatusProcessing,
        _ => HistoryStrings.sheetStatusFailed,
      };

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: _color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            _label,
            style: TextStyle(
              color: _color,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      );
}
