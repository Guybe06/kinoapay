import "dart:ui";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:kinoapay_app/core/constants/kinoa_colors.dart";
import "package:kinoapay_app/core/constants/kinoa_routes.dart";
import "package:kinoapay_app/core/navigation/presentation/widgets/kinoa_bottom_nav.dart";
import "package:kinoapay_app/core/navigation/presentation/widgets/kinoa_header.dart";
import "package:kinoapay_app/features/dashboard/presentation/dashboard_view.dart";
import "package:kinoapay_app/features/send/presentation/send_view.dart";

/// Arguments de navigation transmis au shell principal.
class ShellArgs {
  final int initialTab;
  final bool fromSplash;

  /// @param initialTab  Index de l'onglet à afficher à l'ouverture (défaut : Dashboard)
  /// @param fromSplash  true si la navigation provient du splash (active le Hero du logo)
  const ShellArgs({
    this.initialTab = KinoaRoutes.tabDashboard,
    this.fromSplash = false,
  });
}

/// Shell principal : fond sombre étendu derrière la status bar,
/// navigation flottante glass en overlay, dégradé brume au bas du contenu.
class KinoaShell extends StatefulWidget {
  final ShellArgs args;
  const KinoaShell({super.key, required this.args});

  @override
  State<KinoaShell> createState() => _KinoaShellState();
}

class _KinoaShellState extends State<KinoaShell> {
  late int _currentTab;

  @override
  void initState() {
    super.initState();
    _currentTab = widget.args.initialTab;
  }

  void _onTabChanged(int index) {
    if (index == _currentTab) return;
    setState(() => _currentTab = index);
  }

  List<Widget> _buildPages() {
    return [
      const DashboardView(),
      const SendView(),
      const _PlaceholderPage(label: "Historique"),
      const _PlaceholderPage(label: "Profil"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    // Hauteur totale occupée par la zone nav (capsule + marges + safe area)
    const double navCapsuleHeight = 64;
    const double navMarginBottom = 12;
    final double navTotalHeight = navCapsuleHeight + navMarginBottom + bottomInset + 12;
    // La brume se positionne juste au-dessus de la nav et remonte vers le contenu
    const double mistHeight = 72;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: KinoaColors.surfaceDark,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: KinoaColors.surfaceDark,
        appBar: KinoaHeader(
          withHero: widget.args.fromSplash && _currentTab == KinoaRoutes.tabDashboard,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
// ... rest of the build method
          children: [
            // ── Pages ──
            IndexedStack(
              index: _currentTab,
              children: _buildPages(),
            ),

            // ── Zone glass : blur + gradient overlay sur toute la zone nav + brume ──
            // ClipRect obligatoire pour que BackdropFilter ne sorte pas de sa zone.
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: navTotalHeight + mistHeight,
              child: IgnorePointer(
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    // Gradient overlay : transparent en haut (blur visible),
                    // surfaceDark opaque en bas (fond solide sous la nav).
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            KinoaColors.surfaceDark.withValues(alpha: 0),
                            KinoaColors.surfaceDark.withValues(alpha: 0.55),
                            KinoaColors.surfaceDark.withValues(alpha: 0.88),
                            KinoaColors.surfaceDark,
                          ],
                          stops: const [0.0, 0.35, 0.65, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Navigation flottante glass ──
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: KinoaBottomNav(
                currentIndex: _currentTab,
                onTabChanged: _onTabChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Page provisoire pour les onglets non encore implémentés.
class _PlaceholderPage extends StatelessWidget {
  final String label;
  const _PlaceholderPage({required this.label});

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    return Container(
      color: KinoaColors.surfaceDark,
      padding: EdgeInsets.only(top: topInset),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(color: KinoaColors.stone500, fontSize: 16),
      ),
    );
  }
}
