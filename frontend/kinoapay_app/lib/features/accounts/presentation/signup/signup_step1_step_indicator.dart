import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/accounts/domain/auth_strings.dart";

/// Pastilles de progression du flux d'inscription.
class SignupStepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String label;

  const SignupStepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 1; i <= totalSteps; i++) ...[
          _dot(active: i <= currentStep),
          if (i < totalSteps) const SizedBox(width: 6),
        ],
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            color: AppColors.quinoaDark.withValues(alpha: 0.4),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _dot({required bool active}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: active ? 20 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? AppColors.quinoaGold : AppColors.quinoaDark.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

/// Raccourci étape 1 sur 2.
class SignupStep1StepIndicator extends StatelessWidget {
  const SignupStep1StepIndicator({super.key});

  @override
  Widget build(BuildContext context) => SignupStepIndicator(
        currentStep: 1,
        totalSteps: 2,
        label: AuthStrings.stepIndicator1,
      );
}
