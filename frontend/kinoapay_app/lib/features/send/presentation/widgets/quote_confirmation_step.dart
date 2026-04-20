import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/navigation/presentation/widgets/app_back_header.dart";
import "package:kinoapay_app/core/widgets/app_scroll_scaffold.dart";
import "package:kinoapay_app/features/send/application/bloc/send_bloc.dart";
import "package:kinoapay_app/features/send/application/bloc/send_event.dart";
import "package:kinoapay_app/features/send/domain/entities/transfer_quote.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";
import "package:kinoapay_app/features/send/domain/transaction_context.dart";

final NumberFormat _fmt = NumberFormat("#,##0", "en_US");

/// Écran de confirmation — uniforme aux autres pages, contenu centré.
class QuoteConfirmationStep extends StatefulWidget {
  final TransferQuote quote;
  final VoidCallback onBack;
  final TransactionContext context;

  const QuoteConfirmationStep({
    super.key,
    required this.quote,
    required this.onBack,
    this.context = TransactionContext.send,
  });

  @override
  State<QuoteConfirmationStep> createState() => _QuoteConfirmationStepState();
}

class _QuoteConfirmationStepState extends State<QuoteConfirmationStep> {
  @override
  Widget build(BuildContext context) {
    return AppScrollScaffold(
      header: AppBackHeader(
        onBack: widget.onBack,
        backLabel: SendStrings.backLabel,
        title: widget.context.isPay
            ? SendStrings.payConfirmTitle
            : SendStrings.confirmTitle,
        subtitle: widget.context.isPay
            ? SendStrings.payConfirmSubtitle
            : SendStrings.confirmSubtitle,
      ),
      builder: (_, ctrl) => SingleChildScrollView(
        controller: ctrl,
        padding: const EdgeInsets.fromLTRB(24, 80, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            _buildAvatar(),
            const SizedBox(height: 12),
            Text(
              widget.quote.recipientName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.quinoaDark,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              SendStrings.quoteWillReceive,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.quinoaDark.withValues(alpha: 0.5),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 28),
            Text(
              _fmt.format(widget.quote.amount),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.quinoaDark,
                fontSize: 56,
                fontWeight: FontWeight.w900,
                letterSpacing: -2,
                height: 1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              SendStrings.amountUnit,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.quinoaDark.withValues(alpha: 0.3),
                fontSize: 16,
                fontWeight: FontWeight.w600,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 40),
            _buildSummaryCard(),
            const SizedBox(height: 40),
            _buildConfirmButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          widget.context.isPay
              ? SendStrings.payQuoteVerifyTitle
              : SendStrings.quoteVerifyTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.quinoaDark,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.8,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          widget.context.isPay
              ? SendStrings.payQuoteVerifySubtitle
              : SendStrings.quoteVerifySubtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.quinoaDark.withValues(alpha: 0.40),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 80,
      height: 80,
      decoration: const BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
      ),
      child: const Icon(
        SolarIconsOutline.user,
        color: AppColors.quinoaDark,
        size: 32,
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.quinoaDark.withValues(alpha: 0.06),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          _SummaryRow(
            label: SendStrings.totalFeesLabel,
            value: SendStrings.amountWithUnit(
              _fmt.format(widget.quote.totalFee),
            ),
          ),
          const SizedBox(height: 16),
          Divider(
            color: AppColors.quinoaDark.withValues(alpha: 0.06),
            height: 1,
          ),
          const SizedBox(height: 16),
          _SummaryRow(
            label: SendStrings.confirmTotalLabel,
            value: SendStrings.amountWithUnit(
              _fmt.format(widget.quote.amountDebited),
            ),
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () => context.read<SendBloc>().add(
          SendConfirmRequested(widget.quote.quoteId),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.quinoaDark,
          foregroundColor: AppColors.quinoaCream,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          widget.context.isPay ? SendStrings.payConfirmBtn : SendStrings.confirmBtn,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
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
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: AppColors.quinoaDark,
            fontSize: isBold ? 18 : 14,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
