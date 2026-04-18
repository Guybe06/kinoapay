import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";

/// Écran plein affichant le loader pendant le traitement d'un transfert.
class ProcessingStep extends StatelessWidget {
  const ProcessingStep({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.quinoaCream,
      body: Center(
        child: CircularProgressIndicator(color: AppColors.quinoaGold),
      ),
    );
  }
}
