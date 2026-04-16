import "package:flutter/material.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/dashboard/domain/dashboard_strings.dart";

class DashboardQuickActions extends StatelessWidget {
  const DashboardQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            DashboardStrings.quickActionsTitle,
            style: TextStyle(
              color: AppColors.quinoaDark,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ActionSquare(
                icon: SolarIconsOutline.addCircle,
                label: DashboardStrings.quickAdd,
              ),
              _ActionSquare(
                icon: SolarIconsOutline.sendSquare,
                label: DashboardStrings.quickSend,
              ),
              _ActionSquare(
                icon: SolarIconsOutline.transferVertical,
                label: DashboardStrings.quickConvert,
              ),
              _ActionSquare(
                icon: SolarIconsOutline.menuDots,
                label: DashboardStrings.quickMore,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionSquare extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActionSquare({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            color: AppColors.quinoaDark,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: TextStyle(
            color: AppColors.quinoaDark.withValues(alpha: 0.7),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
