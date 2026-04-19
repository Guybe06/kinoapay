import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/features/accounts/domain/auth_strings.dart";

/// Lien "Pas encore de compte ? S'inscrire" affiché en bas de l'écran de connexion.
class AuthSignupLink extends StatelessWidget {
  final VoidCallback? onTap;

  const AuthSignupLink({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: onTap ?? () => Navigator.pushNamed(context, AppRoutes.signup),
        child: Text.rich(
          TextSpan(
            text: "${AuthStrings.signinNoAccount} ",
            style: TextStyle(color: AppColors.quinoaDark.withValues(alpha: 0.5), fontWeight: FontWeight.w500),
            children: const [
              TextSpan(
                text: AuthStrings.signinSignupLink,
                style: TextStyle(color: AppColors.quinoaDark, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
