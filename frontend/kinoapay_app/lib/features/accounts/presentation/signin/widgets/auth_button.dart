import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";

/// Bouton d'action principal.
class AuthButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isSecondary;

  const AuthButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.only(
      topLeft: Radius.zero,
      topRight: Radius.circular(24),
      bottomLeft: Radius.circular(24),
      bottomRight: Radius.circular(24),
    );

    return SizedBox(
      width: double.infinity,
      height: 64, // Augmenté pour correspondre au WelcomeView
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSecondary ? Colors.white : KinoaColors.stone900,
          foregroundColor: isSecondary ? KinoaColors.stone900 : Colors.white,
          elevation: 0,
          splashFactory: NoSplash.splashFactory,
          overlayColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
            borderRadius: borderRadius,
          ),
          side: isSecondary 
              ? const BorderSide(color: KinoaColors.stone900, width: 2)
              : BorderSide.none,
          disabledBackgroundColor: KinoaColors.stone900.withValues(alpha: 0.5),
        ),
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
      ),
    );
  }
}
