import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";

/// Bouton de connexion via un fournisseur externe (Google, Apple…).
class AuthSocialButton extends StatelessWidget {
  final Widget icon;
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
            icon,
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
