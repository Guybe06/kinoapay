import "package:flutter/material.dart";
import "package:lucide_icons/lucide_icons.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";

/// Barre d'actions rapides permettant d'accéder aux fonctionnalités clés.
class DashboardQuickActions extends StatelessWidget {
  const DashboardQuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: KinoaColors.stone200, width: 1),
        ),
      ),
      child: Row(
        children: [
          _QuickActionItem(
            icon: LucideIcons.send,
            label: "Envoyer",
            onTap: () {},
          ),
          _QuickActionItem(
            icon: LucideIcons.clock,
            label: "Activité",
            onTap: () {},
            hasLeftBorder: true,
          ),
          _QuickActionItem(
            icon: LucideIcons.shieldCheck,
            label: "Vérifier",
            onTap: () {},
            hasLeftBorder: true,
          ),
        ],
      ),
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool hasLeftBorder;

  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.hasLeftBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            border: hasLeftBorder
                ? const Border(left: BorderSide(color: KinoaColors.stone200, width: 1))
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: KinoaColors.stone100,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18, color: KinoaColors.stone900),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: KinoaColors.stone500,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
