import "dart:ui";
import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/core/navigation/domain/nav_item.dart";
import "package:kinoapay_app/core/navigation/domain/nav_items.dart";

/// Navigation principale flottante — capsule glassmorphisme ancrée en bas de page.
/// Positionnée via Positioned dans le Stack du shell, jamais en bottomNavigationBar.
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
      // Marges latérales : la capsule flotte sans toucher les bords
      padding: EdgeInsets.fromLTRB(20, 0, 20, bottomInset + 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              // Fond sombre semi-transparent, cohérent avec surfaceDark
              color: KinoaColors.stone900.withValues(alpha: 0.88),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.07),
                width: 1,
              ),
            ),
            child: Row(
              children: List.generate(
                NavItems.all.length,
                (i) => _NavTab(
                  item: NavItems.all[i],
                  isActive: i == currentIndex,
                  onTap: () => onTabChanged(i),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavTab extends StatelessWidget {
  final NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavTab({required this.item, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Color iconColor = isActive ? KinoaColors.quinoaGold : KinoaColors.stone500;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Fond pill subtil sur l'onglet actif
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: isActive
                    ? KinoaColors.quinoaGold.withValues(alpha: 0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isActive ? item.activeIcon : item.icon,
                size: 22,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 3),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 220),
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                color: iconColor,
              ),
              child: Text(item.label),
            ),
          ],
        ),
      ),
    );
  }
}
