import "dart:ui";
import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/navigation/domain/nav_items.dart";

/// Navigation flottante premium avec effet de glissement fluide.
/// Glassmorphism et indicateur synchronisé avec précision.
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    
    // Dimensions mathématiques pour un alignement parfait
    const itemSize = 48.0;
    const spacing = 12.0;
    const padding = 6.0;
    
    // Calcul de la position de l'indicateur : index * (taille + espacement)
    final indicatorLeft = currentIndex * (itemSize + spacing);

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottomInset + 12),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              height: itemSize + (padding * 2),
              padding: const EdgeInsets.all(padding),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.5), 
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.quinoaDark.withValues(alpha: 0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Indicateur de déplacement fluide (synchronisé)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.fastOutSlowIn,
                    left: indicatorLeft,
                    child: Container(
                      width: itemSize,
                      height: itemSize,
                      decoration: const BoxDecoration(
                        color: AppColors.quinoaDark,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Items de navigation (Row sans marges internes polluantes)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(NavItems.all.length, (i) {
                      final item = NavItems.all[i];
                      final active = i == currentIndex;

                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => onTabChanged(i),
                            behavior: HitTestBehavior.opaque,
                            child: SizedBox(
                              width: itemSize,
                              height: itemSize,
                              child: Center(
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: Icon(
                                    active ? item.activeIcon : item.icon,
                                    key: ValueKey<bool>(active),
                                    size: 24,
                                    color: active
                                        ? Colors.white
                                        : AppColors.quinoaDark.withValues(alpha: 0.35),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Ajout de l'espacement entre les items (sauf le dernier)
                          if (i < NavItems.all.length - 1)
                            const SizedBox(width: spacing),
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
