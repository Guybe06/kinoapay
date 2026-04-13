import "package:equatable/equatable.dart";

/// Types de notification supportés par l'application.
enum NotificationType { transaction, system, promo }

/// Notification reçue par l'utilisateur, liée ou non à une transaction.
class KinoaNotification extends Equatable {
  final String id;
  final NotificationType type;
  final String title;
  final String body;
  final DateTime receivedAt;
  final bool isRead;

  /// Identifiant KinoaTx associé, si la notification concerne une transaction.
  final String? ktxid;

  const KinoaNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    required this.receivedAt,
    required this.isRead,
    this.ktxid,
  });

  KinoaNotification markRead() => KinoaNotification(
        id: id,
        type: type,
        title: title,
        body: body,
        receivedAt: receivedAt,
        isRead: true,
        ktxid: ktxid,
      );

  @override
  List<Object?> get props => [id, isRead];
}
