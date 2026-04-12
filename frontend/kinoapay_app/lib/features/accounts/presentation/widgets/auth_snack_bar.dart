import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";

/// Affiche des notifications toast standardisées pour les écrans d'authentification.
abstract final class AuthSnackBar {
  static const _shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topRight: Radius.circular(20),
      bottomLeft: Radius.circular(20),
      bottomRight: Radius.circular(20),
    ),
  );

  static void showSuccess(BuildContext context, String message) =>
      _show(context, message, KinoaColors.success, Icons.check_circle_outline);

  static void showError(BuildContext context, String message) =>
      _show(context, message, KinoaColors.quinoaRed, Icons.error_outline);

  static void _show(BuildContext context, String message, Color color, IconData icon) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: _shape,
        content: Row(
          children: [
            Icon(icon, color: KinoaColors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: KinoaColors.white, fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ),
          ],
        ),
      ));
  }
}
