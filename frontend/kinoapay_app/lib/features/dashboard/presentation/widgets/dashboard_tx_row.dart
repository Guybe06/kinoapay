import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_tx_row_models.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_tx_row_widgets.dart";

/// Ligne d’aperçu d’une transaction (liste du tableau de bord).
class DashboardTxRow extends StatelessWidget {
  final Transaction tx;
  const DashboardTxRow({super.key, required this.tx});

  DashboardTxNature get _nature {
    final s = tx.status.toUpperCase();
    if (s == "FAILED" || s == "REJECTED" || s == "CANCELLED") {
      return DashboardTxNature.refused;
    }
    if (s == "PROCESSING") return DashboardTxNature.processing;
    if (s == "PENDING") return DashboardTxNature.pending;
    return tx.direction == "received"
        ? DashboardTxNature.received
        : DashboardTxNature.sent;
  }

  @override
  Widget build(BuildContext context) {
    final bool isReceived = tx.direction == "received";
    final nature = _nature;

    final String name = isReceived
        ? (tx.senderName ?? tx.receiverIdentifier)
        : (tx.receiverName ?? tx.receiverIdentifier);

    final fmt = NumberFormat.currency(
      symbol: "",
      decimalDigits: 0,
      locale: "fr_FR",
    );
    final String timeLabel = dashboardTxRelativeDate(tx.startedAt);

    final String source = tx.sourceChannel.toUpperCase();
    final String destination = tx.destinationChannel.toUpperCase();

    final Color amountColor = isReceived
        ? AppColors.quinoaGold
        : AppColors.quinoaDark;
    final double amountSize = isReceived ? 14.0 : 16.0;

    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: !isReceived
            ? BoxDecoration(
                color: AppColors.quinoaDark.withValues(alpha: 0.02),
                border: Border(
                  left: BorderSide(
                    color: AppColors.quinoaDark.withValues(alpha: 0.15),
                    width: 2,
                  ),
                ),
              )
            : null,
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name.toUpperCase(),
                    style: TextStyle(
                      color: AppColors.quinoaDark,
                      fontSize: isReceived ? 11 : 12,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    tx.receiverIdentifier,
                    style: TextStyle(
                      color: AppColors.quinoaDark.withValues(alpha: 0.40),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    timeLabel,
                    style: TextStyle(
                      color: AppColors.quinoaDark.withValues(alpha: 0.30),
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      DashboardTxChannelBadge(label: source),
                      Icon(
                        SolarIconsOutline.arrowRight,
                        size: 10,
                        color: AppColors.quinoaDark.withValues(alpha: 0.25),
                      ),
                      DashboardTxChannelBadge(label: destination),
                    ],
                  ),
                  const SizedBox(height: 6),
                  DashboardTxAmlSparkline(
                    score: (tx.amlScore ?? 0.1).clamp(0.0, 1.0),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${isReceived ? "+" : "−"} ${fmt.format(tx.amount).trim()}",
                    style: TextStyle(
                      color: amountColor,
                      fontSize: amountSize,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  DashboardTxCompactStatus(nature: nature),
                  const SizedBox(height: 2),
                  Text(
                    tx.currency,
                    style: TextStyle(
                      color: AppColors.quinoaDark.withValues(alpha: 0.25),
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                    ),
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
