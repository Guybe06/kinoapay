import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/accounts/domain/auth_strings.dart";
import "package:kinoapay_app/features/accounts/presentation/widgets/auth_social_button.dart";

/// Rangée de deux boutons sociaux (Google + Apple).
class AuthSocialRow extends StatelessWidget {
  const AuthSocialRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AuthSocialButton(
            icon: const FaIcon(FontAwesomeIcons.google, color: AppColors.quinoaDark, size: 20),
            label: AuthStrings.socialGoogle,
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: AuthSocialButton(
            icon: const FaIcon(FontAwesomeIcons.apple, color: AppColors.quinoaDark, size: 20),
            label: AuthStrings.socialApple,
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
