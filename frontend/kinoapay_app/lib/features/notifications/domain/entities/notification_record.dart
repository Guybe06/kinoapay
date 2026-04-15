import "package:equatable/equatable.dart";

/// Catégories de notification côté client.
enum NotificationType { transaction, system, promo }

/// Notification reçue par l'utilisateur, liée ou non à une transaction.
class NotificationRecord extends Equatable {
  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime receivedAt;
  final bool isRead;

  /// Identifiant de transaction associé, si la notification concerne une opération.
  final String? relatedTransactionId;

  const NotificationRecord({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.receivedAt,
    required this.isRead,
    this.relatedTransactionId,
  });

  NotificationRecord markRead() => NotificationRecord(
        id: id,
        type: type,
        title: title,
        body: body,
        receivedAt: receivedAt,
        isRead: true,
        relatedTransactionId: relatedTransactionId,
      );

  @override
  List<Object?> get props => [id, isRead];
}
