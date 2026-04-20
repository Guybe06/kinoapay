import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/navigation/presentation/widgets/app_back_header.dart";
import "package:kinoapay_app/features/send/application/bloc/send_bloc.dart";
import "package:kinoapay_app/features/send/application/bloc/send_event.dart";
import "package:kinoapay_app/features/send/domain/entities/transfer_quote.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";

final NumberFormat _fmt = NumberFormat("#,##0", "en_US");

/// Écran de confirmation — uniforme aux autres pages, contenu centré.
class QuoteConfirmationStep extends StatefulWidget {
  final TransferQuote quote;
  final VoidCallback onBack;

  const QuoteConfirmationStep({
    super.key,
    required this.quote,
    required this.onBack,
  });

  @override
  State<QuoteConfirmationStep> createState() => _QuoteConfirmationStepState();
}

class _QuoteConfirmationStepState extends State<QuoteConfirmationStep> {
  final _scrollController = ScrollController();
  bool _headerVisible = true;
  double _lastOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scrollController.offset;

    if (offset <= 0) {
      if (!_headerVisible) setState(() => _headerVisible = true);
      _lastOffset = offset;
      return;
    }

    final delta = offset - _lastOffset;
    _lastOffset = offset;

    if (delta > 4 && _headerVisible) {
      setState(() => _headerVisible = false);
    } else if (delta < -4 && !_headerVisible) {
      setState(() => _headerVisible = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.quinoaCream,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
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
                    "va recevoir",
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
          ),
          _buildFloatingHeader(),
        ],
      ),
    );
  }

  Widget _buildFloatingHeader() {
    final topInset = MediaQuery.of(context).padding.top;
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: _headerVisible
          ? AppBackHeader(
              onBack: widget.onBack,
              backLabel: "Retour",
              title: "Vérification",
              subtitle: "Confirmez votre transaction",
            )
          : SizedBox(height: topInset),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Vérifiez l'envoi",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.quinoaDark,
            fontSize: 28,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.8,
            height: 1.1,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Dernière étape avant la confirmation",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0x661D2125), // quinoaDark with values alpha 0.4
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
        border: Border.all(color: AppColors.quinoaDark.withValues(alpha: 0.06), width: 1),
      ),
      child: Column(
        children: [
          _SummaryRow(
            label: SendStrings.totalFeesLabel,
            value: SendStrings.amountWithUnit(_fmt.format(widget.quote.totalFee)),
          ),
          const SizedBox(height: 16),
          Divider(
            color: AppColors.quinoaDark.withValues(alpha: 0.06),
            height: 1,
          ),
          const SizedBox(height: 16),
          _SummaryRow(
            label: SendStrings.confirmTotalLabel,
            value: SendStrings.amountWithUnit(_fmt.format(widget.quote.amountDebited)),
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
        onPressed: () =>
            context.read<SendBloc>().add(SendConfirmRequested(widget.quote.quoteId)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.quinoaDark,
          foregroundColor: AppColors.quinoaCream,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          SendStrings.confirmBtn,
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
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
