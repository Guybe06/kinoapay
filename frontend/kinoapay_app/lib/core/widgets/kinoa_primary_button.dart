import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";

/// Bouton d'action principal réutilisable à travers toutes les features.
/// Variante sombre par défaut, variante secondaire outline disponible.
class KinoaPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isSecondary;
  final double height;

  const KinoaPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isSecondary = false,
    this.height = 64,
  });

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.only(
      topRight: Radius.circular(24),
      bottomLeft: Radius.circular(24),
      bottomRight: Radius.circular(24),
    );

    return SizedBox(
      width: double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSecondary ? KinoaColors.white : KinoaColors.quinoaDark,
          foregroundColor: isSecondary ? KinoaColors.quinoaDark : KinoaColors.white,
          elevation: 0,
          splashFactory: NoSplash.splashFactory,
          overlayColor: Colors.transparent,
          shape: const RoundedRectangleBorder(borderRadius: borderRadius),
          side: isSecondary ? const BorderSide(color: KinoaColors.quinoaDark, width: 2) : BorderSide.none,
          disabledBackgroundColor: KinoaColors.quinoaDark.withValues(alpha: 0.4),
        ),
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(strokeWidth: 2, color: KinoaColors.white),
              )
            : Text(text, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
      ),
    );
  }
}
