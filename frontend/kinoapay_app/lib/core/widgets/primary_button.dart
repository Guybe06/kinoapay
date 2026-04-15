import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";

/// Bouton d'action principal réutilisable à travers toutes les features.
/// Variante sombre par défaut, variante secondaire outline disponible.
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isSecondary;
  final bool enabled;
  final double height;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isSecondary = false,
    this.enabled = true,
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
        onPressed: isLoading || !enabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSecondary ? AppColors.white : AppColors.quinoaDark,
          foregroundColor: isSecondary ? AppColors.quinoaDark : AppColors.white,
          elevation: 0,
          splashFactory: NoSplash.splashFactory,
          overlayColor: Colors.transparent,
          shape: const RoundedRectangleBorder(borderRadius: borderRadius),
          side: isSecondary
              ? const BorderSide(color: AppColors.quinoaDark, width: 2)
              : BorderSide.none,
          disabledBackgroundColor: AppColors.quinoaDark.withValues(alpha: 0.4),
        ),
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white,
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
      ),
    );
  }
}
