import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";

/// Bouton d'action du sheet contact (Envoyer / Demander).
class ContactActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool secondary;
  final VoidCallback onTap;

  const ContactActionBtn({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.secondary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: secondary
              ? AppColors.quinoaDark.withValues(alpha: 0.06)
              : AppColors.quinoaDark,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 15,
              color: secondary ? AppColors.quinoaDark : AppColors.white,
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                color: secondary ? AppColors.quinoaDark : AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
