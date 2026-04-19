import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/navigation/presentation/widgets/app_back_header.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";

/// Écran de traitement sécurisé pendant l'exécution du transfert.
class ProcessingStep extends StatelessWidget {
  const ProcessingStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.quinoaCream,
      body: Column(
        children: [
          AppBackHeader(
            onBack: () => Navigator.pop(context),
            backLabel: SendStrings.backToDashboard,
            title: SendStrings.processingTitle,
            subtitle: SendStrings.processing,
          ),
          const Expanded(
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.quinoaGold,
                strokeWidth: 2.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
