import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:solar_icons/solar_icons.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/constants/app_routes.dart";
import "package:kinoapay_app/core/navigation/presentation/widgets/app_back_header.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_bloc.dart";
import "package:kinoapay_app/features/accounts/application/bloc/auth_event.dart";
import "package:kinoapay_app/features/plus/domain/plus_strings.dart";
import "package:kinoapay_app/features/plus/presentation/widgets/plus_sections.dart";
import "package:kinoapay_app/features/plus/presentation/widgets/plus_widgets.dart";

/// Vue principale de la feature Plus.
class PlusView extends StatefulWidget {
  final int unreadNotifications;
  final VoidCallback? onBackToDashboard;

  const PlusView({super.key, this.unreadNotifications = 0, this.onBackToDashboard});

  @override
  State<PlusView> createState() => _PlusViewState();
}

class _PlusViewState extends State<PlusView> {
  final _scrollController = ScrollController();
  bool _headerVisible = true;
  double _lastOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final offset = _scrollController.offset;
    final delta = offset - _lastOffset;
    _lastOffset = offset;
    if (delta > 4 && _headerVisible) {
      setState(() => _headerVisible = false);
    } else if (delta < -4 && !_headerVisible) {
      setState(() => _headerVisible = true);
    }
  }

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
    return Scaffold(
      backgroundColor: AppColors.quinoaCream,
      body: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          SafeArea(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.fromLTRB(20, 72, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    PlusStrings.title,
                    style: TextStyle(
                      color: AppColors.quinoaDark,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.8,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    PlusStrings.subtitle,
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 32),
                  GridView.count(
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
                        onTap: () => Navigator.pushNamed(context, AppRoutes.scanner),
                      ),
                      PlusActionCard(
                        icon: SolarIconsOutline.cardReceive,
                        label: PlusStrings.actionRequest,
                        description: PlusStrings.descRequest,
                        color: AppColors.pending,
                        onTap: () {},
                      ),
                      PlusActionCard(
                        icon: SolarIconsOutline.history,
                        label: PlusStrings.actionHistory,
                        description: PlusStrings.descHistory,
                        color: AppColors.quinoaGold,
                        onTap: () => Navigator.pushNamed(context, AppRoutes.history),
                      ),
                      PlusActionCard(
                        icon: SolarIconsOutline.card2,
                        label: PlusStrings.actionChannels,
                        description: PlusStrings.descChannels,
                        color: AppColors.success,
                        onTap: () => Navigator.pushNamed(context, AppRoutes.channels),
                      ),
                      PlusActionCard(
                        icon: SolarIconsOutline.usersGroupTwoRounded,
                        label: PlusStrings.actionContacts,
                        description: PlusStrings.descContacts,
                        color: AppColors.quinoaDark,
                        onTap: () => Navigator.pushNamed(context, AppRoutes.contacts),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _SectionsBlock(onSignOut: () => _confirmSignOut(context)),
                ],
              ),
            ),
          ),
          _buildFloatingHeader(),
        ],
      ),
    );
  }

  Widget _buildFloatingHeader() {
    final topInset = MediaQuery.of(context).padding.top;
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: _headerVisible
          ? AppBackHeader(
              onBack: widget.onBackToDashboard ?? () {},
              backLabel: PlusStrings.backLabel,
              title: PlusStrings.title,
              subtitle: PlusStrings.headerSubtitle,
              unreadNotifications: widget.unreadNotifications,
            )
          : SizedBox(height: topInset),
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
