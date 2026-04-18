import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/send/application/bloc/send_bloc.dart";
import "package:kinoapay_app/features/send/application/bloc/send_event.dart";
import "package:kinoapay_app/features/send/domain/entities/transfer_quote.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";

const Color _darkBg = Color(0xFF1A1208);

/// Écran de confirmation — fond sombre, montant centré en héros, initiale du destinataire.
class QuoteConfirmationStep extends StatelessWidget {
  final TransferQuote quote;

  const QuoteConfirmationStep({super.key, required this.quote});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat("#,###", "fr_FR");
    return Scaffold(
      backgroundColor: _darkBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 32, 28, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAvatar(),
              const SizedBox(height: 16),
              Text(
                quote.recipientName,
                style: const TextStyle(
                  color: AppColors.quinoaCream,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                fmt.format(quote.amount),
                style: const TextStyle(
                  color: AppColors.quinoaCream,
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
                  color: AppColors.quinoaCream.withValues(alpha: 0.35),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 40),
              _buildFeesCard(fmt),
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
    final initial =
        quote.recipientName.isNotEmpty ? quote.recipientName[0].toUpperCase() : "?";
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: AppColors.quinoaGold,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            color: AppColors.quinoaCream,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _buildFeesCard(NumberFormat fmt) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.quinoaCream.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _FeeRow(
            label: SendStrings.feeKinoa,
            value: SendStrings.amountWithUnit(fmt.format(quote.platformFee)),
          ),
          const SizedBox(height: 12),
          _FeeRow(
            label: SendStrings.feeOperator,
            value: SendStrings.amountWithUnit(fmt.format(quote.operatorFee)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Divider(
              color: AppColors.quinoaCream.withValues(alpha: 0.08),
              height: 1,
            ),
          ),
          _FeeRow(
            label: SendStrings.confirmTotalLabel,
            value: SendStrings.amountWithUnit(fmt.format(quote.amountDebited)),
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
          backgroundColor: AppColors.quinoaCream,
          foregroundColor: AppColors.quinoaDark,
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
          color: AppColors.quinoaCream.withValues(alpha: 0.4),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _FeeRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _FeeRow({
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
            color: AppColors.quinoaCream.withValues(alpha: isBold ? 0.7 : 0.45),
            fontSize: 13,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: isBold
                ? AppColors.quinoaCream
                : AppColors.quinoaCream.withValues(alpha: 0.6),
            fontSize: isBold ? 15 : 13,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
