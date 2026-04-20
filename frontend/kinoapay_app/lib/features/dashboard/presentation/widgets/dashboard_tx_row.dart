import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:intl/intl.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/domain/kinoa_user_type.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";
import "package:kinoapay_app/features/dashboard/presentation/widgets/dashboard_tx_row_models.dart";

/// Ligne de transaction — 2 colonnes : identité + montant.
final _fmt = NumberFormat("#,##0", "en_US");

class DashboardTxRow extends StatelessWidget {
  final Transaction tx;

  const DashboardTxRow({super.key, required this.tx});

  @override
  Widget build(BuildContext context) {
    final bool isReceived = tx.direction == "received";
    final String name = isReceived
        ? (tx.senderName ?? tx.receiverIdentifier)
        : (tx.receiverName ?? tx.receiverIdentifier);

    final String timeLabel = dashboardTxRelativeDate(tx.startedAt);
    final String channel =
        "${tx.sourceChannel} → ${tx.destinationChannel}";

    final Color amountColor =
        isReceived ? AppColors.quinoaGold : AppColors.quinoaDark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          _TxAvatar(isReceived: isReceived),
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
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Text(
                      channel,
                      style: TextStyle(
                        color: AppColors.quinoaDark.withValues(alpha: 0.38),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    if (tx.counterpartType.badgeLabel != null) ...[
                      const SizedBox(width: 6),
                      _DashboardUserTypeBadge(type: tx.counterpartType),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  timeLabel,
                  style: TextStyle(
                    color: AppColors.quinoaDark.withValues(alpha: 0.25),
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${isReceived ? "+" : "−"} ${_fmt.format(tx.amount)}",
                style: TextStyle(
                  color: amountColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                tx.currency,
                style: TextStyle(
                  color: AppColors.quinoaDark.withValues(alpha: 0.25),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Badge type utilisateur — même logique que dans history_tx_row.
class _DashboardUserTypeBadge extends StatelessWidget {
  final KinoaUserType type;
  const _DashboardUserTypeBadge({required this.type});

  Color get _color => type == KinoaUserType.merchant
      ? AppColors.quinoaGold
      : AppColors.quinoaDark.withValues(alpha: 0.35);

  @override
  Widget build(BuildContext context) {
    final label = type.badgeLabel;
    if (label == null) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: _color,
          fontSize: 9,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _TxAvatar extends StatelessWidget {
  final bool isReceived;
  const _TxAvatar({required this.isReceived});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: isReceived
            ? AppColors.quinoaGold.withValues(alpha: 0.10)
            : AppColors.quinoaDark.withValues(alpha: 0.06),
        shape: BoxShape.circle,
      ),
      child: Icon(
        isReceived
            ? SolarIconsOutline.arrowLeftDown
            : SolarIconsOutline.arrowRightUp,
        size: 18,
        color: isReceived
            ? AppColors.quinoaGold
            : AppColors.quinoaDark.withValues(alpha: 0.55),
      ),
    );
  }
}
