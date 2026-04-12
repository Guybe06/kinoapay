import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/core/constants/kinoa_routes.dart";
import "package:kinoapay_app/core/constants/kinoa_strings.dart";

class _NavTab {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavTab({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

/// Onglets du shell dans l'ordre des index [KinoaRoutes.tabDashboard] à [tabProfile].
const List<_NavTab> _tabs = [
  _NavTab(
    icon: Icons.home_outlined,
    activeIcon: Icons.home_rounded,
    label: KinoaStrings.navDashboard,
  ),
  _NavTab(
    icon: Icons.send_outlined,
    activeIcon: Icons.send_rounded,
    label: KinoaStrings.navTransfer,
  ),
  _NavTab(
    icon: Icons.receipt_long_outlined,
    activeIcon: Icons.receipt_long_rounded,
    label: KinoaStrings.navHistory,
  ),
  _NavTab(
    icon: Icons.person_outline_rounded,
    activeIcon: Icons.person_rounded,
    label: KinoaStrings.navProfile,
  ),
];

/// Barre de navigation inférieure persistante du shell KinoaPay.
class KinoaBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  const KinoaBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: KinoaColors.navBackground,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(
              _tabs.length,
              (index) => _buildTab(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(int index) {
    final bool isActive = index == currentIndex;
    final tab = _tabs[index];

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabChanged(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isActive ? tab.activeIcon : tab.icon,
                key: ValueKey(isActive),
                size: 22,
                color: isActive ? KinoaColors.navActive : KinoaColors.navInactive,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? KinoaColors.navActive : KinoaColors.navInactive,
              ),
              child: Text(tab.label),
            ),
          ],
        ),
      ),
    );
  }
}
