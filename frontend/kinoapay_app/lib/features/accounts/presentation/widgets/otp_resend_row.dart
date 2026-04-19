import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/accounts/domain/auth_strings.dart";

/// Bouton / compteur de renvoi OTP selon l'état du délai et du verrouillage.
class OtpResendRow extends StatelessWidget {
  final int countdown;
  final int attempt;
  final int maxAttempts;
  final DateTime? lockedUntil;
  final VoidCallback onResend;

  const OtpResendRow({
    super.key,
    required this.countdown,
    required this.attempt,
    required this.maxAttempts,
    required this.onResend,
    this.lockedUntil,
  });

  bool get _isLockedOut =>
      lockedUntil != null && DateTime.now().isBefore(lockedUntil!);

  @override
  Widget build(BuildContext context) {
    if (_isLockedOut) {
      final r = lockedUntil!.difference(DateTime.now());
      return Text(
        "${AuthStrings.resetRateLimited} ${r.inHours}h${r.inMinutes.remainder(60).toString().padLeft(2, "0")}",
        style: TextStyle(
          color: AppColors.quinoaRed.withValues(alpha: 0.7),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      );
    }
    if (countdown > 0) {
      return Text.rich(
        TextSpan(
          text: "${AuthStrings.otpResendIn} ",
          style: TextStyle(
            color: AppColors.quinoaDark.withValues(alpha: 0.4),
            fontSize: 14,
          ),
          children: [
            TextSpan(
              text: "${countdown}s",
              style: const TextStyle(
                color: AppColors.quinoaDark,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }
    final label = maxAttempts > 1
        ? "${AuthStrings.otpResend} ($attempt/$maxAttempts)"
        : AuthStrings.otpResend;
    return TextButton(
      onPressed: onResend,
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.quinoaDark,
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
