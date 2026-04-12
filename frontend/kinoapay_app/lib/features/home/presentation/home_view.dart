import "dart:ui";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/features/dashboard/presentation/dashboard_view.dart";
import "package:kinoapay_app/core/widgets/kinoa_brand.dart";

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  
  // Traduction de la constante NAV de navbar.tsx avec CupertinoIcons (plus arrondis)
  final List<Map<String, dynamic>> _navItems = [
    {"label": "Accueil", "icon": CupertinoIcons.house_fill},
    {"label": "Envoyer", "icon": CupertinoIcons.paperplane_fill},
    {"label": "Transactions", "icon": CupertinoIcons.arrow_right_arrow_left},
    {"label": "Demander", "icon": CupertinoIcons.money_dollar_circle_fill},
    {"label": "Profil", "icon": CupertinoIcons.person_circle_fill},
  ];

  @override
  Widget build(BuildContext context) {
    // isNavPage est toujours vrai ici car HomeView gère les routes de base
    const bool isNavPage = true; 

    return Scaffold(
      backgroundColor: KinoaColors.stone950, // Fond sombre uniforme
      body: Stack(
        children: [
          // Content Area
          IndexedStack(
            index: _currentIndex,
            children: [
              const DashboardView(),
              const Center(child: Text("Envoyer", style: TextStyle(color: Colors.white))),
              const Center(child: Text("Transactions", style: TextStyle(color: Colors.white))),
              const Center(child: Text("Demander", style: TextStyle(color: Colors.white))),
              const Center(child: Text("Profil", style: TextStyle(color: Colors.white))),
            ],
          ),

          // Sticky Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _StickyHeader(isNavPage: isNavPage),
          ),

          // Floating Bottom Nav
          if (isNavPage)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom + 12,
                  top: 60,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      KinoaColors.stone950.withValues(alpha: 0.0),
                      KinoaColors.stone950,
                    ],
                  ),
                ),
                child: _BottomNavPill(
                  items: _navItems,
                  currentIndex: _currentIndex,
                  onTap: (index) => setState(() => _currentIndex = index),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StickyHeader extends StatelessWidget {
  final bool isNavPage;
  const _StickyHeader({required this.isNavPage});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 8,
            bottom: 12,
            left: 16,
            right: 16,
          ),
          decoration: BoxDecoration(
            color: KinoaColors.stone950.withValues(alpha: 0.8),
          ),
          child: Row(
            children: [
              if (isNavPage) ...[
                const KinoaBrand(
                  size: BrandSize.sm,
                  color: Colors.white,
                  iconColor: KinoaColors.accent,
                ),
                const Spacer(),
                _HeaderIconButton(icon: CupertinoIcons.search),
                const SizedBox(width: 8),
                _HeaderIconButton(icon: CupertinoIcons.bell, badge: "•"),
              ] else ...[
                _NavActionBtn(icon: CupertinoIcons.chevron_left, label: "Retour", onTap: () => Navigator.pop(context)),
                const Expanded(
                  child: Center(
                    child: Text("Titre Page", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _NavActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _NavActionBtn({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: Colors.white),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final String? badge;
  final VoidCallback? onTap;

  const _HeaderIconButton({required this.icon, this.badge, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, size: 16, color: Colors.white),
          ),
          if (badge != null)
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: KinoaColors.primary, shape: BoxShape.circle),
                child: Text(badge!, style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w900)),
              ),
            ),
        ],
      ),
    );
  }
}

class _BottomNavPill extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final int currentIndex;
  final Function(int) onTap;

  const _BottomNavPill({
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 5,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color(0xFF261D15).withValues(alpha: 0.88), // Même couleur brune que le Hero
                borderRadius: BorderRadius.circular(100),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(items.length, (index) {
                  final bool active = index == currentIndex;
                  final item = items[index];

                  return GestureDetector(
                    onTap: () => onTap(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      padding: EdgeInsets.symmetric(
                        horizontal: active ? 18 : 12,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: active ? KinoaColors.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: !active ? Colors.transparent : Colors.white.withValues(alpha: 0.15),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            item["icon"],
                            size: 20,
                            color: active ? Colors.white : Colors.white.withValues(alpha: 0.4),
                          ),
                          if (active) ...[
                            const SizedBox(width: 8),
                            Text(
                              item["label"],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.2,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
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
