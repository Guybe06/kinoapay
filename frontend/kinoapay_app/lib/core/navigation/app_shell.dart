import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/core/navigation/presentation/widgets/bottom_nav.dart";
import "package:kinoapay_app/core/navigation/presentation/widgets/app_header.dart";
import "package:kinoapay_app/features/dashboard/presentation/dashboard_view.dart";
import "package:kinoapay_app/features/history/presentation/history_view.dart";
import "package:kinoapay_app/features/profile/presentation/profile_view.dart";
import "package:kinoapay_app/features/send/presentation/send_view.dart";

/// Arguments de navigation transmis au [KinoaShell] à l'ouverture.
class ShellArgs {
  final int initialTab;
  final bool fromSplash;
  const ShellArgs({
    this.initialTab = KinoaRoutes.tabDashboard,
    this.fromSplash = false,
  });
}

/// Shell principal, fond quinoaCream, icônes status bar sombres, navigation flottante centrée en bas.
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

  List<Widget> _buildPages(BuildContext context) {
    return [
      DashboardView(
        onNavigateToSend: () => _onTabChanged(KinoaRoutes.tabTransfer),
        onNavigateToRequest: () => _onTabChanged(KinoaRoutes.tabTransfer),
        onNavigateToHistory: () => _onTabChanged(KinoaRoutes.tabHistory),
      ),
      const SendView(),
      const HistoryView(),
      const ProfileView(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: KinoaColors.quinoaCream,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: KinoaColors.quinoaCream,
        appBar: KinoaHeader(
          withHero:
              widget.args.fromSplash && _currentTab == KinoaRoutes.tabDashboard,
        ),
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: Stack(
          children: [
            IndexedStack(index: _currentTab, children: _buildPages(context)),
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
