import "package:flutter/material.dart";
import "package:kinoapay_app/core/widgets/app_snack_bar.dart";

/// Alias de [AppSnackBar] pour les écrans d'authentification.
/// Utiliser [AppSnackBar] directement dans les nouvelles features.
abstract final class AuthSnackBar {
  static void showSuccess(BuildContext context, String message) =>
      AppSnackBar.showSuccess(context, message);

  static void showError(BuildContext context, String message) =>
      AppSnackBar.showError(context, message);
}
