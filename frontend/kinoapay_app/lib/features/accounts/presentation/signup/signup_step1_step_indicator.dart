import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";

/// Pastilles « Étape 1 sur 2 ».
class SignupStep1StepIndicator extends StatelessWidget {
  const SignupStep1StepIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _dot(active: true),
        const SizedBox(width: 6),
        _dot(active: false),
        const SizedBox(width: 10),
        Text(
          "Étape 1 sur 2",
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
