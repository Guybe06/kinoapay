import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:kinoapay_app/core/constants/app_colors.dart";
import "package:kinoapay_app/features/notifications/domain/entities/notification_record.dart";

class NotificationTile extends StatelessWidget {
  final KinoaNotification notification;
  final VoidCallback onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final (icon, iconBg, iconColor) = _iconFor(notification.type);
    final timeLabel = _formatTime(notification.receivedAt);

    return InkWell(
      onTap: onTap,
      child: Container(
        color: notification.isRead
            ? Colors.transparent
            : KinoaColors.quinoaGold.withValues(alpha: 0.04),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          style: TextStyle(
                            color: KinoaColors.quinoaDark,
                            fontSize: 13,
                            fontWeight: notification.isRead
                                ? FontWeight.w600
                                : FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        timeLabel,
                        style: TextStyle(
                          color: KinoaColors.quinoaWarmGray.withValues(alpha: 0.5),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    notification.body,
                    style: TextStyle(
                      color: KinoaColors.quinoaDark.withValues(alpha: 0.55),
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            if (!notification.isRead)
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 2),
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: KinoaColors.quinoaGold,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  (IconData, Color, Color) _iconFor(NotificationType type) {
    return switch (type) {
      NotificationType.transaction => (
          Icons.swap_horiz_rounded,
          KinoaColors.accentDark.withValues(alpha: 0.12),
          KinoaColors.accentDark,
        ),
      NotificationType.system => (
          Icons.shield_outlined,
          KinoaColors.quinoaGold.withValues(alpha: 0.15),
          KinoaColors.quinoaGold,
        ),
      NotificationType.promo => (
          Icons.card_giftcard_rounded,
          KinoaColors.quinoaRed.withValues(alpha: 0.10),
          KinoaColors.quinoaRed,
        ),
    };
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return "${diff.inMinutes}min";
    if (diff.inHours < 24) return "${diff.inHours}h";
    return DateFormat("d MMM", "fr_FR").format(dt);
  }
}
