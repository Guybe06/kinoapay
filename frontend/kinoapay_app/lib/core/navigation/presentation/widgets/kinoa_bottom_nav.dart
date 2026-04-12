import "dart:ui";
import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/core/navigation/domain/nav_item.dart";
import "package:kinoapay_app/core/navigation/domain/nav_items.dart";

/// Navigation principale flottante — capsule glassmorphisme ancrée en bas de page.
/// Onglet actif : pill icon + label alignés horizontalement.
/// Onglets inactifs : icône seule, centré.
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
        borderRadius: BorderRadius.circular(26),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: KinoaColors.stone900.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.07),
                width: 1,
              ),
            ),
            child: Row(
              children: List.generate(NavItems.all.length, (i) {
                final bool active = i == currentIndex;
                return _NavTab(
                  item: NavItems.all[i],
                  isActive: active,
                  // L'onglet actif prend plus de place pour accueillir le label
                  flex: active ? 3 : 2,
                  onTap: () => onTabChanged(i),
                );
              }),
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
  final int flex;
  final VoidCallback onTap;

  const _NavTab({
    required this.item,
    required this.isActive,
    required this.flex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: flex,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            ),
            child: isActive ? _ActivePill(item: item) : _InactiveIcon(item: item),
          ),
        ),
      ),
    );
  }
}

/// Pill dorée avec icône + label côte à côte — affiché uniquement sur l'onglet actif.
class _ActivePill extends StatelessWidget {
  final NavItem item;
  const _ActivePill({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey("active"),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      decoration: BoxDecoration(
        color: KinoaColors.quinoaGold.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: KinoaColors.quinoaGold.withValues(alpha: 0.22),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(item.activeIcon, size: 18, color: KinoaColors.quinoaGold),
          const SizedBox(width: 7),
          Text(
            item.label,
            style: const TextStyle(
              color: KinoaColors.quinoaGold,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Icône seule, sans label — pour les onglets inactifs.
class _InactiveIcon extends StatelessWidget {
  final NavItem item;
  const _InactiveIcon({required this.item});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: const ValueKey("inactive"),
      width: 44,
      height: 44,
      child: Icon(item.icon, size: 22, color: KinoaColors.stone500),
    );
  }
}
