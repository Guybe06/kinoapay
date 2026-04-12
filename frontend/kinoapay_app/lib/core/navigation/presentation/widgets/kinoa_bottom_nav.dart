import "dart:ui";
import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/core/navigation/domain/nav_item.dart";
import "package:kinoapay_app/core/navigation/domain/nav_items.dart";

/// Navigation flottante style Dynamic Island — s'adapte à son contenu, centré en bas.
/// L'onglet actif (pill dorée + label) dilate naturellement la capsule.
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

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset + 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
            child: Container(
              decoration: BoxDecoration(
                color: KinoaColors.stone900.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
              child: Row(
                // Taille dictée par le contenu — pas d'étirement
                mainAxisSize: MainAxisSize.min,
                children: List.generate(NavItems.all.length, (i) {
                  return _NavTab(
                    item: NavItems.all[i],
                    isActive: i == currentIndex,
                    onTap: () => onTabChanged(i),
                  );
                }),
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

  const _NavTab({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOut,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        padding: EdgeInsets.symmetric(
          // La pill active a plus de padding horizontal pour accueillir le label
          horizontal: isActive ? 14 : 11,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isActive ? KinoaColors.quinoaGold : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? item.activeIcon : item.icon,
              size: 20,
              color: isActive ? Colors.white : KinoaColors.stone500,
            ),
            if (isActive) ...[
              const SizedBox(width: 6),
              Text(
                item.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
