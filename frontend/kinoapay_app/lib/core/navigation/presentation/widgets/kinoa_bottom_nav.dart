import "dart:ui";
import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/core/navigation/domain/nav_item.dart";
import "package:kinoapay_app/core/navigation/domain/nav_items.dart";

/// Navigation principale flottante.
/// Taille dictée par le contenu (IntrinsicHeight).
/// Onglet actif : pill quinoaGold pleine opacité, texte + icône blancs.
/// Onglets inactifs : icône seule stone500.
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
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            decoration: BoxDecoration(
              color: KinoaColors.stone900.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.07),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            child: IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: List.generate(NavItems.all.length, (i) {
                  final bool active = i == currentIndex;
                  return _NavTab(
                    item: NavItems.all[i],
                    isActive: active,
                    flex: active ? 3 : 2,
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
            duration: const Duration(milliseconds: 230),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.85, end: 1.0).animate(anim),
                child: child,
              ),
            ),
            child: isActive
                ? _ActivePill(key: const ValueKey("active"), item: item)
                : _InactiveIcon(key: ValueKey("inactive_${item.label}"), item: item),
          ),
        ),
      ),
    );
  }
}

class _ActivePill extends StatelessWidget {
  final NavItem item;
  const _ActivePill({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        // Fond plein, pas d'opacité réduite
        color: KinoaColors.quinoaGold,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(item.activeIcon, size: 18, color: Colors.white),
          const SizedBox(width: 7),
          Text(
            item.label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _InactiveIcon extends StatelessWidget {
  final NavItem item;
  const _InactiveIcon({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Icon(item.icon, size: 22, color: KinoaColors.stone500),
    );
  }
}
