import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/dashboard_strings.dart";

/// Navigateur mois / année affiché dans l'en-tête de la carte de statistiques.
class DashboardStatsMonthNavigator extends StatelessWidget {
  final int month;
  final int year;
  final bool canGoNext;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const DashboardStatsMonthNavigator({
    super.key,
    required this.month,
    required this.year,
    required this.canGoNext,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final raw = DateFormat("MMM yyyy", "fr_FR").format(DateTime(year, month));
    final label = raw[0].toUpperCase() + raw.substring(1);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _NavArrow(icon: SolarIconsOutline.altArrowLeft, onTap: onPrev, enabled: true),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: AppColors.quinoaCream.withValues(alpha: 0.70),
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(width: 6),
        _NavArrow(
          icon: SolarIconsOutline.altArrowRight,
          onTap: onNext,
          enabled: canGoNext,
        ),
      ],
    );
  }
}

class _NavArrow extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  const _NavArrow({
    required this.icon,
    required this.onTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Icon(
        icon,
        size: 13,
        color: enabled
            ? AppColors.quinoaCream.withValues(alpha: 0.55)
            : AppColors.quinoaCream.withValues(alpha: 0.15),
      ),
    );
  }
}

/// Badge positif / négatif affiché à côté du montant net.
class DashboardStatsDeltaBadge extends StatelessWidget {
  final bool isPositive;

  const DashboardStatsDeltaBadge({super.key, required this.isPositive});

  @override
  Widget build(BuildContext context) {
    final color = isPositive ? AppColors.quinoaGold : AppColors.quinoaRed;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive
                ? Icons.arrow_upward_rounded
                : Icons.arrow_downward_rounded,
            size: 10,
            color: color,
          ),
          const SizedBox(width: 3),
          Text(
            isPositive
                ? DashboardStrings.netPositiveBadge
                : DashboardStrings.netNegativeBadge,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

/// Colonne stat (label + montant) alignée à gauche, au centre ou à droite.
class DashboardStatsStatColumn extends StatelessWidget {
  final String label;
  final String amount;
  final IconData icon;
  final Color color;
  final bool center;
  final bool alignRight;

  const DashboardStatsStatColumn({
    super.key,
    required this.label,
    required this.amount,
    required this.icon,
    required this.color,
    this.center = false,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    final cross = alignRight
        ? CrossAxisAlignment.end
        : center
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start;

    final pad = EdgeInsets.only(
      left: center || alignRight ? 16 : 0,
      right: center || !alignRight ? 16 : 0,
    );

    return Padding(
      padding: pad,
      child: Column(
        crossAxisAlignment: cross,
        children: [
          Row(
            mainAxisAlignment: alignRight
                ? MainAxisAlignment.end
                : center
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
            children: [
              Icon(icon, size: 11, color: color.withValues(alpha: 0.70)),
              const SizedBox(width: 4),
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  color: color.withValues(alpha: 0.55),
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            amount,
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.3,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
