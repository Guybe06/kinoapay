import "dart:ui";
import "package:flutter/material.dart";
import "package:lucide_icons/lucide_icons.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/core/constants/kinoa_strings.dart";

class _NavTab {
  final IconData icon;
  final String label;
  const _NavTab({required this.icon, required this.label});
}

const List<_NavTab> _tabs = [
  _NavTab(icon: LucideIcons.home, label: KinoaStrings.navDashboard),
  _NavTab(icon: LucideIcons.send, label: KinoaStrings.navTransfer),
  _NavTab(icon: LucideIcons.clock, label: KinoaStrings.navHistory),
  _NavTab(icon: LucideIcons.user, label: KinoaStrings.navProfile),
];

/// Navigation flottante glassmorphisme — positionnée en overlay dans le shell.
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
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, bottomInset + 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.12),
                width: 1,
              ),
            ),
            child: Row(
              children: List.generate(
                _tabs.length,
                (i) => _buildItem(i),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(int index) {
    final bool active = index == currentIndex;
    final tab = _tabs[index];

    return Expanded(
      child: GestureDetector(
        onTap: () => onTabChanged(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: active ? KinoaColors.accent.withValues(alpha: 0.15) : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                tab.icon,
                size: 20,
                color: active ? KinoaColors.accent : KinoaColors.stone500,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 10,
                fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                color: active ? KinoaColors.accent : KinoaColors.stone500,
              ),
              child: Text(tab.label),
            ),
          ],
        ),
      ),
    );
  }
}
