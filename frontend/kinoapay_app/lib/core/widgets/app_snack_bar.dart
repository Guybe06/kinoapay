import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";

/// Notifications toast standardisées pour toute l'application.
abstract final class AppSnackBar {
  static const _shape = RoundedRectangleBorder(
    borderRadius: BorderRadius.only(
      topRight: Radius.circular(20),
      bottomLeft: Radius.circular(20),
      bottomRight: Radius.circular(20),
    ),
  );

  static void showSuccess(BuildContext context, String message) =>
      _show(context, message, AppColors.success, Icons.check_circle_outline);

  static void showError(BuildContext context, String message) =>
      _show(context, message, AppColors.quinoaRed, Icons.error_outline);

  /// Toast informatif neutre — pour les messages qui ne sont ni succès ni erreur.
  static void showInfo(BuildContext context, String message) =>
      _show(context, message, AppColors.quinoaDark, Icons.info_outline);

  static void _show(
    BuildContext context,
    String message,
    Color color,
    IconData icon,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: _shape,
        content: Row(
          children: [
            Icon(icon, color: AppColors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ));
  }
}
