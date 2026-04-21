import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";

/// Carte d'info groupée avec titre de section en majuscules.
class ProfileSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const ProfileSection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.quinoaDark.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: AppColors.quinoaDark.withValues(alpha: 0.35),
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}

/// Ligne label / valeur utilisée dans [ProfileSection].
class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.quinoaDark.withValues(alpha: 0.5),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.quinoaDark,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Avatar circulaire avec les initiales de l'utilisateur.
class ProfileAvatar extends StatelessWidget {
  final String? name;
  final bool compact;

  const ProfileAvatar({super.key, this.name, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final initials = _initials(name ?? "");
    return Container(
      width: compact ? 60 : 72,
      height: compact ? 60 : 72,
      decoration: BoxDecoration(
        color: AppColors.quinoaGold.withValues(alpha: 0.15),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: AppColors.quinoaGold,
          fontSize: compact ? 22 : 26,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  /// Extrait les deux premières initiales du nom complet.
  static String _initials(String name) {
    final parts = name.trim().split(" ").where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      return "${parts[0][0]}${parts[1][0]}".toUpperCase();
    }
    if (parts.isNotEmpty) return parts[0][0].toUpperCase();
    return "?";
  }
}

/// Badge statut KYC : vert si vérifié, or si non vérifié.
class ProfileKycBadge extends StatelessWidget {
  final bool verified;
  final String label;

  const ProfileKycBadge({
    super.key,
    required this.verified,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final color = verified ? AppColors.success : AppColors.quinoaGold;
    final icon = verified
        ? SolarIconsOutline.shieldCheck
        : SolarIconsOutline.shieldWarning;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
