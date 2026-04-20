import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:intl/intl.dart" show DateFormat;
import "package:qr_flutter/qr_flutter.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/utils/amount_formatter.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";
import "package:kinoapay_app/features/history/domain/history_strings.dart";

/// Fiche récap compacte d'une transaction — bottom sheet.
///
/// Le QR code encode les données essentielles de la transaction,
/// scannable pour une vérification ou un reçu complet.
class HistoryTxDetailSheet extends StatelessWidget {
  final Transaction tx;

  const HistoryTxDetailSheet({super.key, required this.tx});

  String get _qrData {
    final isSent = tx.direction == "sent";
    final dateFmt = DateFormat("d MMMM yyyy à HH:mm", "fr_FR");
    final status = switch (tx.status) {
      "COMPLETED" => HistoryStrings.sheetStatusCompleted,
      "PENDING" => HistoryStrings.sheetStatusPending,
      "PROCESSING" => HistoryStrings.sheetStatusProcessing,
      _ => HistoryStrings.sheetStatusFailed,
    };
    final dir = isSent ? "Envoyé à" : "Reçu de";
    final who = isSent
        ? (tx.receiverName ?? tx.receiverIdentifier)
        : (tx.senderName ?? tx.receiverIdentifier);

    return [
      "REÇU KINOAPAY",
      "Réf: ${tx.transactionId}",
      "Montant: ${AmountFormatter.withCurrency(tx.amount)}",
      "$dir: $who (${tx.receiverIdentifier})",
      "Canal: ${tx.sourceChannel} → ${tx.destinationChannel}",
      "Date: ${dateFmt.format(tx.startedAt)}",
      "Statut: $status",
    ].join("\n");
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.78,
      minChildSize: 0.45,
      maxChildSize: 0.92,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            _Handle(),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 36),
                children: [
                  _AmountHeader(tx: tx),
                  const SizedBox(height: 16),
                  _InfoCard(tx: tx),
                  const SizedBox(height: 12),
                  _FeeRow(fees: tx.fees),
                  const SizedBox(height: 20),
                  _QrBlock(data: _qrData, ref: tx.transactionId),
                  const SizedBox(height: 12),
                  _CopyRefButton(ref: tx.transactionId),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Handle extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          margin: const EdgeInsets.only(top: 12, bottom: 6),
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.quinoaDark.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      );
}

/// Bloc montant + statut + route canal — zone principale de lecture rapide.
class _AmountHeader extends StatelessWidget {
  final Transaction tx;
  const _AmountHeader({required this.tx});

  Color get _statusColor => switch (tx.status) {
        "COMPLETED" => AppColors.success,
        "PENDING" || "PROCESSING" => AppColors.warning,
        _ => AppColors.quinoaRed,
      };

  String get _statusLabel => switch (tx.status) {
        "COMPLETED" => HistoryStrings.sheetStatusCompleted,
        "PENDING" => HistoryStrings.sheetStatusPending,
        "PROCESSING" => HistoryStrings.sheetStatusProcessing,
        _ => HistoryStrings.sheetStatusFailed,
      };

  @override
  Widget build(BuildContext context) {
    final isSent = tx.direction == "sent";
    final sign = isSent ? "−" : "+";
    final amtColor = tx.status == "FAILED"
        ? AppColors.quinoaDark.withValues(alpha: 0.35)
        : isSent
            ? AppColors.quinoaDark
            : AppColors.accentDark;
    final name = isSent
        ? (tx.receiverName ?? tx.receiverIdentifier)
        : (tx.senderName ?? tx.receiverIdentifier);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isSent ? HistoryStrings.sheetTo : HistoryStrings.sheetFrom,
              style: TextStyle(
                color: AppColors.quinoaDark.withValues(alpha: 0.40),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _statusColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 5,
                    height: 5,
                    decoration: BoxDecoration(
                      color: _statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    _statusLabel,
                    style: TextStyle(
                      color: _statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              name,
              style: const TextStyle(
                color: AppColors.quinoaDark,
                fontSize: 17,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          "$sign ${AmountFormatter.format(tx.amount)} ${HistoryStrings.currency}",
          style: TextStyle(
            color: amtColor,
            fontSize: 38,
            fontWeight: FontWeight.w900,
            letterSpacing: -1.5,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "${tx.sourceChannel} → ${tx.destinationChannel}",
          style: TextStyle(
            color: AppColors.quinoaDark.withValues(alpha: 0.30),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// Tableau compact des infos clés de la transaction.
class _InfoCard extends StatelessWidget {
  final Transaction tx;
  const _InfoCard({required this.tx});

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat("d MMM yyyy · HH:mm", "fr_FR");

    return Container(
      decoration: BoxDecoration(
        color: AppColors.quinoaDark.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.quinoaDark.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: [
          _Row(label: HistoryStrings.sheetRef, value: tx.transactionId, mono: true),
          _Sep(),
          _Row(
            label: HistoryStrings.sheetDate,
            value: dateFmt.format(tx.startedAt),
          ),
        ],
      ),
    );
  }
}

/// Ligne frais totaux compacte.
class _FeeRow extends StatelessWidget {
  final TransactionFees fees;
  const _FeeRow({required this.fees});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          HistoryStrings.sheetFeeSection,
          style: TextStyle(
            color: AppColors.quinoaDark.withValues(alpha: 0.40),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          AmountFormatter.withCurrency(fees.totalFee),
          style: const TextStyle(
            color: AppColors.quinoaDark,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

/// Bloc QR code réel — scannable pour vérification du reçu.
class _QrBlock extends StatelessWidget {
  final String data;
  final String ref;

  const _QrBlock({required this.data, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.quinoaDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                HistoryStrings.sheetQrTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                HistoryStrings.sheetQrSub,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.35),
                  fontSize: 11,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: QrImageView(
                data: data,
                version: QrVersions.auto,
                size: 152,
                eyeStyle: const QrEyeStyle(
                  eyeShape: QrEyeShape.square,
                  color: Color(0xFF1A1A2E),
                ),
                dataModuleStyle: const QrDataModuleStyle(
                  dataModuleShape: QrDataModuleShape.square,
                  color: Color(0xFF1A1A2E),
                ),
                backgroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            ref,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.30),
              fontSize: 10,
              fontFamily: "monospace",
              letterSpacing: 0.8,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _CopyRefButton extends StatefulWidget {
  final String ref;
  const _CopyRefButton({required this.ref});

  @override
  State<_CopyRefButton> createState() => _CopyRefButtonState();
}

class _CopyRefButtonState extends State<_CopyRefButton> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.ref));
    setState(() => _copied = true);
    await Future<void>.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => _copied = false);
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: _copy,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.quinoaDark.withValues(alpha: 0.10),
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              _copied ? HistoryStrings.copiedRef : HistoryStrings.copyRef,
              style: TextStyle(
                color: _copied ? AppColors.success : AppColors.quinoaDark,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      );
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool mono;

  const _Row({required this.label, required this.value, this.mono = false});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: AppColors.quinoaDark.withValues(alpha: 0.40),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: AppColors.quinoaDark,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  fontFamily: mono ? "monospace" : null,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
}

class _Sep extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Divider(
        height: 1,
        indent: 14,
        endIndent: 14,
        color: AppColors.quinoaDark.withValues(alpha: 0.05),
      );
}
