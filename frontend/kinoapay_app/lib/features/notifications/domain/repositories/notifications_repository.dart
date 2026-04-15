import "package:kinoapay_app/features/notifications/domain/entities/notification_record.dart";

/// Contrat d'accès aux notifications utilisateur.
abstract class NotificationsRepository {
  Future<List<NotificationRecord>> getNotifications();

  /// Marque une notification comme lue par son identifiant.
  Future<void> markAsRead(String id);

  /// Marque toutes les notifications comme lues.
  Future<void> markAllAsRead();
}
