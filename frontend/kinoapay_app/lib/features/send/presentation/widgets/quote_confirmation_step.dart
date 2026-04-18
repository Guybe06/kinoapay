import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/navigation/presentation/widgets/app_header.dart";
import "package:kinoapay_app/features/send/application/bloc/send_bloc.dart";
import "package:kinoapay_app/features/send/application/bloc/send_event.dart";
import "package:kinoapay_app/features/send/domain/entities/transfer_quote.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";

final NumberFormat _fmt = NumberFormat("#,##0", "en_US");

/// Écran de confirmation — fond blanc, user icon, frais globaux.
class QuoteConfirmationStep extends StatelessWidget {
  final TransferQuote quote;
  final VoidCallback onBack;

  const QuoteConfirmationStep({
    super.key,
    required this.quote,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.quinoaCream,
      appBar: const AppHeader(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildBackButton(),
            const SizedBox(height: 20),
            _buildHeader(),
            const SizedBox(height: 20),
            _buildAvatar(),
            const SizedBox(height: 10),
            Text(
              quote.recipientName,
              style: const TextStyle(
                color: AppColors.quinoaDark,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "va recevoir",
              style: TextStyle(
                color: AppColors.quinoaDark.withValues(alpha: 0.5),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
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
            const SizedBox(height: 6),
            Text(
              SendStrings.amountUnit,
              style: TextStyle(
                color: AppColors.quinoaDark.withValues(alpha: 0.3),
                fontSize: 15,
                fontWeight: FontWeight.w400,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 28),
            _buildSummaryCard(),
            const SizedBox(height: 32),
            _buildConfirmButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 64,
      height: 64,
      decoration: const BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        SolarIconsOutline.user,
        color: AppColors.quinoaDark,
        size: 26,
      ),
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: onBack,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.quinoaDark.withValues(alpha: 0.07),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          SolarIconsOutline.altArrowLeft,
          color: AppColors.quinoaDark,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          SendStrings.confirmTitle,
          style: const TextStyle(
            color: AppColors.quinoaDark,
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Vérifiez les détails avant d'envoyer",
          style: TextStyle(
            color: AppColors.quinoaDark.withValues(alpha: 0.4),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
