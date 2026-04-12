import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/core/navigation/domain/nav_item.dart";
import "package:kinoapay_app/core/navigation/domain/nav_items.dart";

/// Navigation flottante light — style Dynamic Island, fond blanc avec ombre douce.
/// Onglet actif : pill quinoaGold pleine, texte + icône blancs.
/// Onglets inactifs : icône seule quinoaWarmGray.
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
        child: Container(
          decoration: BoxDecoration(
            color: KinoaColors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: KinoaColors.quinoaDark.withValues(alpha: 0.06),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: KinoaColors.quinoaDark.withValues(alpha: 0.10),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: KinoaColors.quinoaDark.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
          child: Row(
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
              color: isActive ? Colors.white : KinoaColors.quinoaWarmGray,
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
