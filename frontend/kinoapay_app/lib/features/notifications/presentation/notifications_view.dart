import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/navigation/presentation/widgets/app_back_header.dart";
import "package:kinoapay_app/core/widgets/app_page_title.dart";
import "package:kinoapay_app/core/widgets/app_scroll_scaffold.dart";
import "package:kinoapay_app/features/notifications/application/bloc/notifications_bloc.dart";
import "package:kinoapay_app/features/notifications/application/bloc/notifications_event.dart";
import "package:kinoapay_app/features/notifications/application/bloc/notifications_state.dart";
import "package:kinoapay_app/features/notifications/domain/notifications_strings.dart";
import "package:kinoapay_app/features/notifications/presentation/widgets/notification_tile.dart";

/// Page notifications avec header scroll-hide et liste dans une carte blanche.
class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationsBloc>().add(const NotificationsStarted());
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<NotificationsBloc>().state;
    final hasUnread =
        state is NotificationsLoadSuccess && state.unreadCount > 0;

    return AppScrollScaffold(
      header: AppBackHeader(
        onBack: () => Navigator.pop(context),
        backLabel: NotificationsStrings.backLabel,
        title: NotificationsStrings.title,
        subtitle: NotificationsStrings.subtitle,
        trailing: hasUnread
            ? GestureDetector(
                onTap: () => context.read<NotificationsBloc>().add(
                  const NotificationsAllMarkedRead(),
                ),
                child: const Text(
                  NotificationsStrings.markAllRead,
                  style: TextStyle(
                    color: AppColors.quinoaGold,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              )
            : null,
      ),
      builder: (_, ctrl) => CustomScrollView(
        controller: ctrl,
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: 52)),
          const SliverToBoxAdapter(
            child: AppPageTitle(
              title: NotificationsStrings.pageTitle,
              subtitle: NotificationsStrings.pageSubtitle,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 8)),
          if (state is NotificationsLoading)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: _NotificationsSkeleton(),
            )
          else if (state is NotificationsLoadSuccess)
            state.notifications.isEmpty
                ? const SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyState(),
                  )
                : SliverToBoxAdapter(child: _NotificationsList(state: state))
          else
            const SliverToBoxAdapter(child: SizedBox.shrink()),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

/// Liste des notifications dans une carte blanche arrondie.
class _NotificationsList extends StatelessWidget {
  final NotificationsLoadSuccess state;
  const _NotificationsList({required this.state});

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColors.quinoaDark.withValues(alpha: 0.06)),
      boxShadow: [
        BoxShadow(
          color: AppColors.quinoaDark.withValues(alpha: 0.04),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Column(
        children: List.generate(state.notifications.length, (i) {
          final n = state.notifications[i];
          final isLast = i == state.notifications.length - 1;
          return Column(
            children: [
              NotificationTile(
                notification: n,
                onTap: () => context.read<NotificationsBloc>().add(
                  NotificationMarkedRead(n.id),
                ),
              ),
              if (!isLast)
                Padding(
                  padding: const EdgeInsets.only(left: 74, right: 20),
                  child: Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.quinoaDark.withValues(alpha: 0.05),
                  ),
                ),
            ],
          );
        }),
      ),
    ),
  );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.quinoaDark.withValues(alpha: 0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.notifications_none_rounded,
          size: 24,
          color: AppColors.quinoaDark.withValues(alpha: 0.25),
        ),
      ),
      const SizedBox(height: 16),
      const Text(
        NotificationsStrings.empty,
        style: TextStyle(
          color: AppColors.quinoaDark,
          fontSize: 15,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.3,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        NotificationsStrings.emptySub,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppColors.quinoaDark.withValues(alpha: 0.40),
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

/// Squelette de chargement : 4 tiles placeholder.
class _NotificationsSkeleton extends StatelessWidget {
  const _NotificationsSkeleton();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.quinoaDark.withValues(alpha: 0.06)),
      ),
      child: Column(
        children: List.generate(4, (i) => _SkeletonTile(last: i == 3)),
      ),
    ),
  );
}

class _SkeletonTile extends StatelessWidget {
  final bool last;
  const _SkeletonTile({required this.last});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.quinoaDark.withValues(alpha: 0.06),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 11,
                    width: 140,
                    decoration: BoxDecoration(
                      color: AppColors.quinoaDark.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 9,
                    decoration: BoxDecoration(
                      color: AppColors.quinoaDark.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      if (!last)
        Padding(
          padding: const EdgeInsets.only(left: 74, right: 20),
          child: Divider(
            height: 1,
            thickness: 1,
            color: AppColors.quinoaDark.withValues(alpha: 0.05),
          ),
        ),
    ],
  );
}
