import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/features/accounts/domain/auth_strings.dart";

/// Lien "Déjà un compte ? Se connecter" affiché en bas de l'étape 2 d'inscription.
class AuthSigninLink extends StatelessWidget {
  const AuthSigninLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.signin),
        child: Text.rich(
          TextSpan(
            text: "${AuthStrings.signupHaveAccount} ",
            style: TextStyle(color: AppColors.quinoaDark.withValues(alpha: 0.5), fontWeight: FontWeight.w500),
            children: const [
              TextSpan(
                text: AuthStrings.signupSigninLink,
                style: TextStyle(color: AppColors.quinoaDark, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
