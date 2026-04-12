import "package:flutter/material.dart";
import "package:kinoapay_app/core/constants/kinoa_routes.dart";
import "package:kinoapay_app/core/widgets/kinoa_bottom_nav.dart";
import "package:kinoapay_app/core/widgets/kinoa_header.dart";

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

/// Shell principal : assemble le header, l'IndexedStack des pages et la bottom nav.
class KinoaShell extends StatefulWidget {
  final ShellArgs args;

  /// @param args  Arguments de navigation (onglet initial, provenance splash)
  const KinoaShell({super.key, required this.args});

  @override
  State<KinoaShell> createState() => _KinoaShellState();
}

class _KinoaShellState extends State<KinoaShell> {
  late int _currentTab;
  late bool _heroActive;

  @override
  void initState() {
    super.initState();
    _currentTab = widget.args.initialTab;
    _heroActive = widget.args.fromSplash;

    if (_heroActive) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _heroActive = false);
      });
    }
  }

  void _onTabChanged(int index) {
    if (index == _currentTab) return;
    setState(() => _currentTab = index);
  }

  List<Widget> _buildPages() {
    return [
      _tabPlaceholder(KinoaRoutes.tabDashboard),
      _tabPlaceholder(KinoaRoutes.tabTransfer),
      _tabPlaceholder(KinoaRoutes.tabHistory),
      _tabPlaceholder(KinoaRoutes.tabProfile),
    ];
  }

  Widget _tabPlaceholder(int index) {
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KinoaHeader(withHero: _heroActive),
      body: IndexedStack(
        index: _currentTab,
        children: _buildPages(),
      ),
      bottomNavigationBar: KinoaBottomNav(
        currentIndex: _currentTab,
        onTabChanged: _onTabChanged,
      ),
    );
  }
}
