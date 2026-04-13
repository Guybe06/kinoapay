import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";

/// Chip de période — flottant en haut du dashboard.
class DashboardHero extends StatelessWidget {
  final VoidCallback onPeriodTap;

  const DashboardHero({super.key, required this.onPeriodTap});

  @override
  Widget build(BuildContext context) {
    final period = DateFormat("MMMM", "fr_FR").format(DateTime.now()).toLowerCase();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _PeriodChip(label: period, onTap: onPeriodTap),
        ],
      ),
    );
  }
}

class _PeriodChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PeriodChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: KinoaColors.quinoaDark.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: KinoaColors.quinoaDark.withValues(alpha: 0.55),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
