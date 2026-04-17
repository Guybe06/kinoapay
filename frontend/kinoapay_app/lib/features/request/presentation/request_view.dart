import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";

/// Écran demande de paiement — placeholder, en construction.
class RequestView extends StatelessWidget {
  const RequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Demander",
        style: TextStyle(
          color: AppColors.quinoaDark,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
