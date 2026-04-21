import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";

/// Carte carrée de la grille d'actions rapides.
class PlusActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const PlusActionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: AppColors.quinoaDark.withValues(alpha: 0.08),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.quinoaDark.withValues(alpha: 0.03),
              blurRadius: 40,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: color, size: 36),
                Icon(
                  SolarIconsOutline.arrowRightUp,
                  color: AppColors.quinoaDark.withValues(alpha: 0.10),
                  size: 24,
                ),
              ],
            ),
            const Spacer(),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.quinoaDark,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.8,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Carte horizontale pleine largeur pour les sections sous la grille.
class PlusListCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final Color color;
  final VoidCallback onTap;
  final bool isDestructive;
  final Widget? trailing;
  final bool compact;

  const PlusListCard({
    super.key,
    required this.icon,
    required this.label,
    required this.description,
    required this.color,
    required this.onTap,
    this.isDestructive = false,
    this.trailing,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = isDestructive ? AppColors.white : AppColors.quinoaDark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 14 : 18,
          vertical: compact ? 10 : 12,
        ),
        decoration: BoxDecoration(
          color: isDestructive ? AppColors.quinoaRed : AppColors.white,
          borderRadius: BorderRadius.circular(compact ? 16 : 20),
          border: Border.all(
            color: isDestructive
                ? AppColors.quinoaRed
                : AppColors.quinoaDark.withValues(alpha: 0.08),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? AppColors.white : color,
              size: compact ? 20 : 22,
            ),
            SizedBox(width: compact ? 12 : 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: labelColor,
                      fontSize: compact ? 14 : 15,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                  SizedBox(height: compact ? 1 : 2),
                  Text(
                    description,
                    style: TextStyle(
                      color: isDestructive
                          ? AppColors.white.withValues(alpha: 0.75)
                          : labelColor.withValues(alpha: 0.45),
                      fontSize: compact ? 11 : 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
                Icon(
                  SolarIconsOutline.altArrowRight,
                  size: compact ? 14 : 16,
                  color: isDestructive
                      ? AppColors.white.withValues(alpha: 0.65)
                      : labelColor.withValues(alpha: 0.25),
                ),
          ],
        ),
      ),
    );
  }
}

/// En-tête de section avec label en majuscules espacées.
class PlusSectionHeader extends StatelessWidget {
  final String label;

  const PlusSectionHeader({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.quinoaDark.withValues(alpha: 0.35),
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.4,
        ),
      ),
    );
  }
}
