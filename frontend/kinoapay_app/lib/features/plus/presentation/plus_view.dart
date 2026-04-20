import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/core/navigation/presentation/widgets/app_back_header.dart";
import "package:kinoapay_app/core/widgets/app_page_title.dart";
import "package:kinoapay_app/core/widgets/app_scroll_scaffold.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_bloc.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_event.dart";
import "package:kinoapay_app/features/plus/domain/plus_strings.dart";
import "package:kinoapay_app/features/plus/presentation/widgets/plus_sections.dart";
import "package:kinoapay_app/features/plus/presentation/widgets/plus_widgets.dart";

/// Vue principale de la feature Plus.
class PlusView extends StatelessWidget {
  final int unreadNotifications;
  final VoidCallback? onBackToDashboard;

  const PlusView({
    super.key,
    this.unreadNotifications = 0,
    this.onBackToDashboard,
  });

  Future<void> _confirmSignOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          PlusStrings.signOutDialogTitle,
          style: TextStyle(
            color: AppColors.quinoaDark,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        content: const Text(
          PlusStrings.signOutDialogMessage,
          style: TextStyle(color: AppColors.textMuted, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              PlusStrings.signOutCancel,
              style: TextStyle(color: AppColors.textMuted),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              PlusStrings.signOutConfirm,
              style: TextStyle(
                color: AppColors.quinoaRed,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.read<AuthBloc>().add(SignOutRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScrollScaffold(
      header: AppBackHeader(
        onBack: onBackToDashboard ?? () {},
        backLabel: PlusStrings.backLabel,
        title: PlusStrings.title,
        subtitle: PlusStrings.headerSubtitle,
        unreadNotifications: unreadNotifications,
      ),
      builder: (_, ctrl) => SingleChildScrollView(
        controller: ctrl,
        padding: const EdgeInsets.fromLTRB(0, 72, 0, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppPageTitle(
              title: PlusStrings.pageTitle,
              subtitle: PlusStrings.pageSubtitle,
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.1,
                children: [
                  PlusActionCard(
                    icon: SolarIconsOutline.scanner,
                    label: PlusStrings.actionScan,
                    description: PlusStrings.descScan,
                    color: AppColors.quinoaDark,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.scanner),
                  ),
                  PlusActionCard(
                    icon: SolarIconsOutline.cardReceive,
                    label: PlusStrings.actionRequest,
                    description: PlusStrings.descRequest,
                    color: AppColors.pending,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.request),
                  ),
                  PlusActionCard(
                    icon: SolarIconsOutline.history,
                    label: PlusStrings.actionHistory,
                    description: PlusStrings.descHistory,
                    color: AppColors.quinoaGold,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.history),
                  ),
                  PlusActionCard(
                    icon: SolarIconsOutline.card2,
                    label: PlusStrings.actionChannels,
                    description: PlusStrings.descChannels,
                    color: AppColors.success,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.channels),
                  ),
                  PlusActionCard(
                    icon: SolarIconsOutline.usersGroupTwoRounded,
                    label: PlusStrings.actionContacts,
                    description: PlusStrings.descContacts,
                    color: AppColors.quinoaDark,
                    onTap: () =>
                        Navigator.pushNamed(context, AppRoutes.contacts),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _SectionsBlock(onSignOut: () => _confirmSignOut(context)),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bloc sections (Mon compte / Support / Session) avec labels inline-start.
class _SectionsBlock extends StatelessWidget {
  final VoidCallback onSignOut;
  const _SectionsBlock({required this.onSignOut});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _SectionDot(label: PlusStrings.sectionAccount),
            const SizedBox(width: 16),
            _SectionDot(label: PlusStrings.sectionSupport),
            const SizedBox(width: 16),
            _SectionDot(label: PlusStrings.sectionSession),
          ],
        ),
        const SizedBox(height: 14),
        const PlusAccountSection(),
        const SizedBox(height: 10),
        const PlusSupportSection(),
        const SizedBox(height: 10),
        PlusListCard(
          icon: SolarIconsOutline.logout,
          label: PlusStrings.actionSignOut,
          description: PlusStrings.descSignOut,
          color: AppColors.quinoaRed,
          isDestructive: true,
          onTap: onSignOut,
        ),
      ],
    );
  }
}

class _SectionDot extends StatelessWidget {
  final String label;
  const _SectionDot({required this.label});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 5,
        height: 5,
        decoration: BoxDecoration(
          color: AppColors.quinoaDark.withValues(alpha: 0.20),
          shape: BoxShape.circle,
        ),
      ),
      const SizedBox(width: 5),
      Text(
        label,
        style: TextStyle(
          color: AppColors.quinoaDark.withValues(alpha: 0.35),
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    ],
  );
}
