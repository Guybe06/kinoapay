import "package:kinoapay_app/features/notifications/domain/entities/notification_record.dart";
import "package:kinoapay_app/features/notifications/domain/repositories/notifications_repository.dart";

/// Simule un flux de notifications : transactions, alertes AML, système, promo.
class MockNotificationsRepository implements NotificationsRepository {
  final List<NotificationRecord> _store = [
    NotificationRecord(
      id: "n001",
      type: NotificationType.transaction,
      title: "Argent reçu",
      body: "Marie Claire vous a envoyé 15 000 XAF via Airtel Money.",
      receivedAt: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: false,
      relatedTransactionId: "TX-2026-T002",
    ),
    NotificationRecord(
      id: "n002",
      type: NotificationType.transaction,
      title: "Transfert confirmé",
      body: "Votre envoi de 25 000 XAF à Jean Dupont a été effectué avec succès.",
      receivedAt: DateTime.now().subtract(const Duration(hours: 1)),
      isRead: false,
      relatedTransactionId: "TX-2026-T001",
    ),
    NotificationRecord(
      id: "n003",
      type: NotificationType.system,
      title: "Alerte conformité",
      body: "Une transaction récente a déclenché une vérification AML. Aucune action requise.",
      receivedAt: DateTime.now().subtract(const Duration(days: 2, hours: 9)),
      isRead: false,
      relatedTransactionId: "TX-2026-D002",
    ),
    NotificationRecord(
      id: "n004",
      type: NotificationType.system,
      title: "Vérification d'identité",
      body: "Complétez votre vérification KYC Tier 2 pour débloquer toutes les fonctionnalités.",
      receivedAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationRecord(
      id: "n005",
      type: NotificationType.promo,
      title: "Invitez vos proches",
      body: "Partagez kinoaPay avec vos contacts et gagnez 500 XAF par parrainage activé.",
      receivedAt: DateTime.now().subtract(const Duration(days: 3)),
      isRead: true,
    ),
    NotificationRecord(
      id: "n006",
      type: NotificationType.transaction,
      title: "Argent reçu",
      body: "Karim Idriss vous a envoyé 35 000 XAF via Airtel Money.",
      receivedAt: DateTime.now().subtract(const Duration(days: 1, hours: 14)),
      isRead: true,
      relatedTransactionId: "TX-2026-H002",
    ),
  ];

  @override
  Future<List<NotificationRecord>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return List.unmodifiable(_store);
  }

  @override
  Future<void> markAsRead(String id) async {
    final index = _store.indexWhere((n) => n.id == id);
    if (index != -1) _store[index] = _store[index].markRead();
  }

  @override
  Future<void> markAllAsRead() async {
    for (int i = 0; i < _store.length; i++) {
      _store[i] = _store[i].markRead();
    }
  }
}
