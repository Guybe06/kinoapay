import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/scanner/domain/entities/scan_result.dart";

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
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 40),
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
          const SizedBox(height: 24),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.quinoaRed.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.qr_code_scanner_rounded,
              size: 28,
              color: AppColors.quinoaRed,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _title(),
            style: const TextStyle(
              color: AppColors.quinoaDark,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _subtitle(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.quinoaDark.withValues(alpha: 0.5),
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 28),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onCancel,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: AppColors.quinoaDark.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "Annuler",
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
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: AppColors.quinoaDark,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _actionLabel(),
                      style: const TextStyle(
                        color: Colors.white,
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
        ScanResultType.publicHandle => "KinoaID détecté",
        ScanResultType.paymentRequest => "Demande de paiement",
        ScanResultType.unknown => "QR non reconnu",
      };

  String _subtitle() => switch (result.type) {
        ScanResultType.publicHandle =>
          "Envoyer de l'argent à ${result.publicHandle ?? result.raw}",
        ScanResultType.paymentRequest =>
          "Payer ${result.amount?.toStringAsFixed(0) ?? "?"} ${result.currency ?? "XAF"} à ${result.publicHandle ?? ""}",
        ScanResultType.unknown => "Ce QR code n'est pas reconnu par kinoaPay.",
      };

  String _actionLabel() => switch (result.type) {
        ScanResultType.publicHandle => "Envoyer",
        ScanResultType.paymentRequest => "Payer",
        ScanResultType.unknown => "OK",
      };
}
