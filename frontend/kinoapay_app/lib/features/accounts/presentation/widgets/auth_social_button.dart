import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/accounts/domain/auth_strings.dart";

/// Bouton de connexion via un fournisseur externe (Google, Apple…).
class AuthSocialButton extends StatelessWidget {
  final dynamic icon;
  final String label;
  final VoidCallback onPressed;

  const AuthSocialButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.only(
      topRight: Radius.circular(20),
      bottomLeft: Radius.circular(20),
      bottomRight: Radius.circular(20),
    );
    return InkWell(
      onTap: onPressed,
      borderRadius: borderRadius,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.7),
          border: Border.all(
            color: AppColors.quinoaDark.withValues(alpha: 0.1),
          ),
          borderRadius: borderRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon is IconData)
              Icon(icon, color: AppColors.quinoaDark, size: 20),
            if (icon is FaIconData)
              FaIcon(icon, color: AppColors.quinoaDark, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.quinoaDark,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Rangée de deux boutons sociaux (Google + Apple).
class AuthSocialRow extends StatelessWidget {
  const AuthSocialRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AuthSocialButton(
            icon: FontAwesomeIcons.google,
            label: AuthStrings.socialGoogle,
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AuthSocialButton(
            icon: FontAwesomeIcons.apple,
            label: AuthStrings.socialApple,
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

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
