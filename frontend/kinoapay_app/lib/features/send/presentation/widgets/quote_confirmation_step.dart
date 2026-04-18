import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/widgets/primary_button.dart";
import "package:kinoapay_app/features/send/application/bloc/send_bloc.dart";
import "package:kinoapay_app/features/send/application/bloc/send_event.dart";
import "package:kinoapay_app/features/send/domain/entities/transfer_quote.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";

/// Étape de confirmation finale : récapitulatif du devis et actions.
class QuoteConfirmationStep extends StatelessWidget {
  final TransferQuote quote;

  const QuoteConfirmationStep({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat("#,###", "fr_FR");
    return Scaffold(
      backgroundColor: AppColors.quinoaCream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                SendStrings.confirmTitle,
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 32),
              _buildSummaryCard(fmt),
              const Spacer(),
              PrimaryButton(
                text: SendStrings.confirmShortBtn,
                onPressed: () => context.read<SendBloc>().add(
                      SendConfirmRequested(quote.quoteId),
                    ),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                text: SendStrings.cancelBtn,
                isSecondary: true,
                onPressed: () => context.read<SendBloc>().add(SendReset()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(NumberFormat fmt) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          _InfoRow(
            label: SendStrings.confirmToLabel,
            value: quote.recipientName,
          ),
          const Divider(height: 32),
          _InfoRow(
            label: SendStrings.feeKinoa,
            value: SendStrings.amountWithUnit(fmt.format(quote.platformFee)),
          ),
          _InfoRow(
            label: SendStrings.feeOperator,
            value: SendStrings.amountWithUnit(fmt.format(quote.operatorFee)),
          ),
          const Divider(height: 32),
          _InfoRow(
            label: SendStrings.confirmTotalLabel,
            value: SendStrings.amountWithUnit(fmt.format(quote.amountDebited)),
            isBold: true,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _InfoRow({
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
            ),
          ),
        ],
      ),
    );
  }
}
