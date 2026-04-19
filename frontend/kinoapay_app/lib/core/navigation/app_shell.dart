import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/core/navigation/presentation/widgets/bottom_nav.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_bloc.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_state.dart";
import "package:kinoapay_app/features/dashboard/presentation/dashboard_view.dart";
import "package:kinoapay_app/features/plus/presentation/plus_view.dart";
import "package:kinoapay_app/features/send/presentation/send_view.dart";

/// Arguments de navigation transmis au [AppShell] à l'ouverture.
class ShellArgs {
  final int initialTab;
  final bool fromSplash;
  const ShellArgs({
    this.initialTab = AppRoutes.tabDashboard,
    this.fromSplash = false,
  });
}

/// Shell principal, fond quinoaCream, barre de navigation standard en bas.
class AppShell extends StatefulWidget {
  final ShellArgs args;
  const AppShell({super.key, required this.args});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
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
    final authState = context.read<AuthBloc>().state;
    final firstName =
        authState is Authenticated ? (authState.user.firstName ?? "") : "";
    final kycVerified =
        authState is Authenticated ? authState.user.kycVerified : false;

    return [
      DashboardView(
        firstName: firstName,
        kycVerified: kycVerified,
        onNavigateToSend: () => _onTabChanged(AppRoutes.tabTransfer),
      ),
      SendView(
        onBackToDashboard: () => _onTabChanged(AppRoutes.tabDashboard),
      ),
      PlusView(
        unreadNotifications: 3,
        onBackToDashboard: () => _onTabChanged(AppRoutes.tabDashboard),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.quinoaCream,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.quinoaCream,
        extendBody: true,
        body: Stack(
          children: [
            IndexedStack(index: _currentTab, children: _buildPages(context)),
            if (_currentTab == AppRoutes.tabDashboard)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: AppBottomNav(
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


