import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/features/accounts/domain/auth_strings.dart";

/// Lien "Mot de passe oublié ? Réinitialiser" affiché sous le champ mot de passe.
class AuthForgotPasswordLink extends StatelessWidget {
  final VoidCallback? onTap;

  const AuthForgotPasswordLink({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Navigator.pushNamed(context, AppRoutes.forgotPassword),
      child: Text.rich(
        TextSpan(
          text: AuthStrings.signinForgotPrefix,
          style: TextStyle(color: AppColors.quinoaDark.withValues(alpha: 0.5), fontSize: 14, fontWeight: FontWeight.w500),
          children: const [
            TextSpan(
              text: AuthStrings.signinResetLink,
              style: TextStyle(color: AppColors.quinoaDark, fontWeight: FontWeight.w800, decoration: TextDecoration.underline),
            ),
          ],
        ),
      ),
    );
  }
}
