import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/core/navigation/presentation/widgets/app_back_header.dart";
import "package:kinoapay_app/core/widgets/app_page_title.dart";
import "package:kinoapay_app/features/notifications/application/bloc/notifications_bloc.dart";
import "package:kinoapay_app/features/notifications/application/bloc/notifications_event.dart";
import "package:kinoapay_app/features/notifications/application/bloc/notifications_state.dart";
import "package:kinoapay_app/features/notifications/presentation/widgets/notification_tile.dart";

/// Liste des notifications avec marquage lu global.
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
    return Scaffold(
      backgroundColor: AppColors.quinoaCream,
      body: Column(
        children: [
          BlocBuilder<NotificationsBloc, NotificationsState>(
            builder: (context, state) => AppBackHeader(
              onBack: () => Navigator.pop(context),
              backLabel: "Accueil",
              title: "Notifications",
              subtitle: "Vos alertes et mises à jour",
              trailing: state is NotificationsLoadSuccess && state.unreadCount > 0
                  ? GestureDetector(
                      onTap: () => context
                          .read<NotificationsBloc>()
                          .add(const NotificationsAllMarkedRead()),
                      child: Text(
                        "Tout lire",
                        style: TextStyle(
                          color: AppColors.quinoaGold,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          const AppPageTitle(
            title: "Restez informé.",
            subtitle: "Vos alertes en temps réel.",
          ),
          Expanded(
            child: BlocBuilder<NotificationsBloc, NotificationsState>(
              builder: (context, state) {
                if (state is NotificationsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.quinoaGold,
                      strokeWidth: 2,
                    ),
                  );
                }
                if (state is NotificationsLoadSuccess) {
                  if (state.notifications.isEmpty) return const _EmptyState();
                  return _NotificationsList(state: state);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

}

class _NotificationsList extends StatelessWidget {
  final NotificationsLoadSuccess state;
  const _NotificationsList({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.quinoaDark.withValues(alpha: 0.06)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: state.notifications.length,
          separatorBuilder: (_, _) => Divider(
            height: 1,
            thickness: 1,
            indent: 74,
            endIndent: 20,
            color: AppColors.quinoaDark.withValues(alpha: 0.05),
          ),
          itemBuilder: (context, i) {
            final n = state.notifications[i];
            return NotificationTile(
              notification: n,
              onTap: () => context
                  .read<NotificationsBloc>()
                  .add(NotificationMarkedRead(n.id)),
            );
          },
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.notifications_none_rounded,
            size: 48,
            color: AppColors.quinoaDark.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 12),
          Text(
            "Aucune notification",
            style: TextStyle(
              color: AppColors.quinoaDark.withValues(alpha: 0.4),
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
