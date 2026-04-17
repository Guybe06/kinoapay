import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";

/// Écran « Plus » — menu secondaire, placeholder en construction.
class MoreView extends StatelessWidget {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Plus",
        style: TextStyle(
          color: AppColors.quinoaDark,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
