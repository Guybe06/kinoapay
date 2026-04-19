import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:intl/intl.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/entities/transaction.dart";
import "package:kinoapay_app/features/history/domain/history_strings.dart";
import "package:kinoapay_app/features/history/presentation/widgets/history_tx_qr.dart";

/// Fiche détail d'une transaction — bottom sheet scrollable.
class HistoryTxDetailSheet extends StatelessWidget {
  final Transaction tx;

  const HistoryTxDetailSheet({super.key, required this.tx});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            _SheetHandle(),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 40),
                children: [
                  _StatusChip(status: tx.status),
                  const SizedBox(height: 20),
                  _AmountBlock(tx: tx),
                  const SizedBox(height: 28),
                  _InfoSection(tx: tx),
                  const SizedBox(height: 24),
                  _FeesSection(fees: tx.fees),
                  const SizedBox(height: 28),
                  _QrSection(tx: tx),
                  const SizedBox(height: 24),
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

class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      width: 40, height: 4,
      decoration: BoxDecoration(
        color: AppColors.quinoaDark.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(2),
      ),
    ),
  );
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  Color get _color => switch (status) {
    "COMPLETED" => AppColors.success,
    "PENDING" => AppColors.warning,
    "PROCESSING" => AppColors.warning,
    _ => AppColors.quinoaRed,
  };

  String get _label => switch (status) {
    "COMPLETED" => HistoryStrings.sheetStatusCompleted,
    "PENDING" => HistoryStrings.sheetStatusPending,
    "PROCESSING" => HistoryStrings.sheetStatusProcessing,
    _ => HistoryStrings.sheetStatusFailed,
  };

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: _color.withValues(alpha: 0.25)),
      ),
      child: Text(
        _label,
        style: TextStyle(color: _color, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 0.3),
      ),
    ),
  );
}

class _AmountBlock extends StatelessWidget {
  final Transaction tx;
  const _AmountBlock({required this.tx});

  @override
  Widget build(BuildContext context) {
    final isSent = tx.direction == "sent";
    final sign = isSent ? "−" : "+";
    final color = isSent ? AppColors.quinoaDark : AppColors.accentDark;
    final fmt = NumberFormat("#,###", "fr_FR");

    return Column(
      children: [
        Text(
          "$sign ${fmt.format(tx.amount)} ${HistoryStrings.currency}",
          style: TextStyle(
            color: color,
            fontSize: 36,
            fontWeight: FontWeight.w900,
            letterSpacing: -1,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          "${tx.sourceChannel} → ${tx.destinationChannel}",
          style: TextStyle(
            color: AppColors.quinoaDark.withValues(alpha: 0.35),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _InfoSection extends StatelessWidget {
  final Transaction tx;
  const _InfoSection({required this.tx});

  @override
  Widget build(BuildContext context) {
    final isSent = tx.direction == "sent";
    final dateFmt = DateFormat("d MMM yyyy · HH:mm", "fr_FR");

    return _Card(
      children: [
        _Row(
          label: isSent ? HistoryStrings.sheetTo : HistoryStrings.sheetFrom,
          value: isSent
              ? (tx.receiverName ?? tx.receiverIdentifier)
              : (tx.senderName ?? tx.receiverIdentifier),
        ),
        _Sep(),
        _Row(label: HistoryStrings.sheetFor, value: tx.receiverIdentifier),
        _Sep(),
        _Row(label: HistoryStrings.sheetRef, value: tx.transactionId, mono: true),
        _Sep(),
        _Row(label: HistoryStrings.sheetDate, value: dateFmt.format(tx.startedAt)),
      ],
    );
  }
}

class _FeesSection extends StatelessWidget {
  final TransactionFees fees;
  const _FeesSection({required this.fees});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat("#,###", "fr_FR");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          HistoryStrings.sheetFeeSection,
          style: TextStyle(color: AppColors.quinoaDark.withValues(alpha: 0.40), fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1.0),
        ),
        const SizedBox(height: 8),
        _Card(
          children: [
            _Row(label: HistoryStrings.sheetFeeOperator, value: "${fmt.format(fees.sourceOperatorFee)} XAF"),
            _Sep(),
            _Row(label: HistoryStrings.sheetFeePlatform, value: "${fmt.format(fees.platformFee)} XAF"),
            _Sep(),
            _Row(label: HistoryStrings.sheetFeeTotal, value: "${fmt.format(fees.totalFee)} XAF", bold: true),
            _Sep(),
            _Row(label: HistoryStrings.sheetDebited, value: "${fmt.format(fees.amountDebited)} XAF", bold: true),
            _Sep(),
            _Row(label: HistoryStrings.sheetReceived, value: "${fmt.format(fees.amountReceived)} XAF", bold: true, color: AppColors.accentDark),
          ],
        ),
      ],
    );
  }
}

class _QrSection extends StatelessWidget {
  final Transaction tx;
  const _QrSection({required this.tx});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: AppColors.quinoaDark,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      children: [
        Text(
          HistoryStrings.sheetQrTitle,
          style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          HistoryStrings.sheetQrSub,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.40), fontSize: 11),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Center(child: HistoryTxQr(seed: tx.transactionId)),
        const SizedBox(height: 16),
        Text(
          tx.transactionId,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.35),
            fontSize: 11,
            fontFamily: "monospace",
            letterSpacing: 1.0,
          ),
        ),
      ],
    ),
  );
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
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: _copy,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.quinoaDark.withValues(alpha: 0.12)),
        borderRadius: BorderRadius.circular(16),
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

class _Card extends StatelessWidget {
  final List<Widget> children;
  const _Card({required this.children});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.quinoaDark.withValues(alpha: 0.03),
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.quinoaDark.withValues(alpha: 0.07)),
    ),
    child: Column(children: children),
  );
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final bool mono;
  final Color? color;

  const _Row({required this.label, required this.value, this.bold = false, this.mono = false, this.color});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      children: [
        Expanded(
          child: Text(label, style: TextStyle(color: AppColors.quinoaDark.withValues(alpha: 0.40), fontSize: 12, fontWeight: FontWeight.w500)),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: color ?? AppColors.quinoaDark,
              fontSize: 12,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
              fontFamily: mono ? "monospace" : null,
            ),
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
    indent: 16,
    endIndent: 16,
    color: AppColors.quinoaDark.withValues(alpha: 0.06),
  );
}
