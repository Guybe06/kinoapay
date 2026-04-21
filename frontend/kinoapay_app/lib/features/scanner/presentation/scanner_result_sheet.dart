import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/helpers/screen_size_helper.dart";
import "package:kinoapay_app/features/scanner/domain/entities/scan_result.dart";
import "package:kinoapay_app/features/scanner/domain/scanner_strings.dart";

/// Feuille modale après lecture d’un QR (confirmation ou retour caméra).
class ScannerResultBottomSheet extends StatelessWidget {
  final ScanResult result;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ScannerResultBottomSheet({
    super.key,
    required this.result,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final compact = ScreenSizeHelper.isSmallOrLess(context);
    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        compact ? 16 : 20,
        24,
        ScreenSizeHelper.adaptiveValue(
          context,
          compact: 28,
          small: 32,
          medium: 36,
          large: 40,
        ),
      ),
      decoration: const BoxDecoration(
        color: AppColors.quinoaCream,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.quinoaDark.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: compact ? 20 : 24),
          Container(
            width: compact ? 48 : 56,
            height: compact ? 48 : 56,
            decoration: BoxDecoration(
              color: AppColors.quinoaRed.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.qr_code_scanner_rounded,
              size: compact ? 24 : 28,
              color: AppColors.quinoaRed,
            ),
          ),
          SizedBox(height: compact ? 12 : 16),
          Text(
            _title(),
            style: TextStyle(
              color: AppColors.quinoaDark,
              fontSize: compact ? 16 : 18,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.4,
            ),
          ),
          SizedBox(height: compact ? 4 : 6),
          Text(
            _subtitle(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.quinoaDark.withValues(alpha: 0.5),
              fontSize: 13,
              height: 1.4,
            ),
          ),
          SizedBox(
            height: ScreenSizeHelper.adaptiveValue(
              context,
              compact: 20,
              small: 24,
              medium: 26,
              large: 28,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onCancel,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: compact ? 12 : 15),
                    decoration: BoxDecoration(
                      color: AppColors.quinoaDark.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      ScannerStrings.cancel,
                      style: TextStyle(
                        color: AppColors.quinoaDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: onConfirm,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: compact ? 12 : 15),
                    decoration: BoxDecoration(
                      color: AppColors.quinoaDark,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _actionLabel(),
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _title() => switch (result.type) {
    ScanResultType.publicHandle => ScannerStrings.resultHandleTitle,
    ScanResultType.paymentRequest => ScannerStrings.resultPayTitle,
    ScanResultType.unknown => ScannerStrings.resultUnknownTitle,
  };

  String _subtitle() => switch (result.type) {
    ScanResultType.publicHandle => ScannerStrings.resultHandleBody(
      result.publicHandle ?? result.raw,
    ),
    ScanResultType.paymentRequest => ScannerStrings.resultPayBody(
      result.amount?.toStringAsFixed(0) ?? "?",
      result.currency ?? "XAF",
      result.publicHandle ?? "",
    ),
    ScanResultType.unknown => ScannerStrings.resultUnknownBody,
  };

  String _actionLabel() => switch (result.type) {
    ScanResultType.publicHandle => ScannerStrings.actionSend,
    ScanResultType.paymentRequest => ScannerStrings.actionPay,
    ScanResultType.unknown => ScannerStrings.actionOk,
  };
}
