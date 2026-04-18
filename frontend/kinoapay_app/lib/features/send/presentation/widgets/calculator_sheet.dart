import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/widgets/primary_button.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";

/// Feuille modale de simulation de frais (mock : 1 % Kinoa, 3 % opérateur).
class CalculatorSheet extends StatelessWidget {
  static const double _kinoaFeeRate = 0.01;
  static const double _operatorFeeRate = 0.03;

  final double amount;
  final String source;
  final String dest;
  final VoidCallback onConfirm;

  const CalculatorSheet({
    super.key,
    required this.amount,
    required this.source,
    required this.dest,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat("#,##0", "en_US");
    final kinoaFee = amount * _kinoaFeeRate;
    final operatorFee = amount * _operatorFeeRate;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        32,
        32,
        32,
        MediaQuery.of(context).padding.bottom + 32,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            SendStrings.simulationTitle,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 4),
          const Text(
            SendStrings.simulationSubtitle,
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 24),
          _CalcRow(
            label: SendStrings.simAmountLabel,
            value: fmt.format(amount),
          ),
          _CalcRow(
            label: SendStrings.simKinoaFeeLabel,
            value: fmt.format(kinoaFee),
          ),
          _CalcRow(
            label: SendStrings.feeOperatorWithRate(dest),
            value: fmt.format(operatorFee),
          ),
          const Divider(height: 32),
          _CalcRow(
            label: SendStrings.simTotalLabel,
            value: fmt.format(amount + kinoaFee + operatorFee),
            isBold: true,
          ),
          const SizedBox(height: 32),
          PrimaryButton(
            text: SendStrings.continueBtn,
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            text: SendStrings.cancelBtn,
            isSecondary: true,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

class _CalcRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _CalcRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.textMuted,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
              fontSize: isBold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
