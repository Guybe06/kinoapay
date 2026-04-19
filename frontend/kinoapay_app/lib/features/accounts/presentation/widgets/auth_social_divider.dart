import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/accounts/domain/auth_strings.dart";

/// Séparateur "OU CONTINUER AVEC" entre le formulaire et les boutons sociaux.
class AuthSocialDivider extends StatelessWidget {
  const AuthSocialDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AuthStrings.socialDivider,
        style: TextStyle(
          color: AppColors.quinoaDark.withValues(alpha: 0.35),
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
