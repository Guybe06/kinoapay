import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/send/application/bloc/send_bloc.dart";
import "package:kinoapay_app/features/send/application/bloc/send_event.dart";
import "package:kinoapay_app/features/send/domain/entities/transfer_quote.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";

final NumberFormat _fmt = NumberFormat("#,##0", "en_US");

/// Écran de confirmation — fond blanc, user icon, frais globaux.
class QuoteConfirmationStep extends StatelessWidget {
  final TransferQuote quote;

  const QuoteConfirmationStep({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.quinoaCream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 32, 28, 32),
          child: Column(
            children: [
              _buildAvatar(),
              const SizedBox(height: 14),
              Text(
                quote.recipientName,
                style: const TextStyle(
                  color: AppColors.quinoaDark,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                _fmt.format(quote.amount),
                style: const TextStyle(
                  color: AppColors.quinoaDark,
                  fontSize: 52,
                  fontWeight: FontWeight.w300,
                  letterSpacing: -2,
                  height: 1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                SendStrings.amountUnit,
                style: TextStyle(
                  color: AppColors.quinoaDark.withValues(alpha: 0.3),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 36),
              _buildSummaryCard(),
              const Spacer(),
              _buildConfirmButton(context),
              const SizedBox(height: 16),
              _buildCancelLink(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 64,
      height: 64,
      decoration: const BoxDecoration(
        color: AppColors.stone100,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        SolarIconsOutline.user,
        color: AppColors.stone400,
        size: 26,
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.stone200, width: 1),
      ),
      child: Column(
        children: [
          _SummaryRow(
            label: SendStrings.totalFeesLabel,
            value: SendStrings.amountWithUnit(_fmt.format(quote.totalFee)),
          ),
          const SizedBox(height: 14),
          Divider(
            color: AppColors.quinoaDark.withValues(alpha: 0.06),
            height: 1,
          ),
          const SizedBox(height: 14),
          _SummaryRow(
            label: SendStrings.confirmTotalLabel,
            value: SendStrings.amountWithUnit(_fmt.format(quote.amountDebited)),
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () =>
            context.read<SendBloc>().add(SendConfirmRequested(quote.quoteId)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.quinoaDark,
          foregroundColor: AppColors.quinoaCream,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: const Text(
          SendStrings.confirmBtn,
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
        ),
      ),
    );
  }

  Widget _buildCancelLink(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<SendBloc>().add(SendReset()),
      child: Text(
        SendStrings.cancelBtn,
        style: TextStyle(
          color: AppColors.quinoaDark.withValues(alpha: 0.4),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.quinoaDark.withValues(alpha: isBold ? 0.8 : 0.45),
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: AppColors.quinoaDark,
            fontSize: isBold ? 16 : 13,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
