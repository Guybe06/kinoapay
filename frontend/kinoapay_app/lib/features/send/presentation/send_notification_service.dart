import "package:flutter_local_notifications/flutter_local_notifications.dart";
import "package:kinoapay_app/features/send/domain/send_strings.dart";

/// Service de notification local pour les envois d'argent.
///
/// Encapsule l'initialisation du plugin et l'envoi de la notification de succès.
/// Le plugin est détenu en statique pour éviter de le recréer entre les sessions.
abstract final class SendNotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  /// Initialise le plugin de notification et demande la permission Android.
  static Future<void> initialize() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings(SendStrings.notifIconResource),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );
    await _plugin.initialize(settings);
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  /// Affiche une notification de confirmation d'envoi réussi.
  static Future<void> showSuccess() async {
    const androidDetails = AndroidNotificationDetails(
      SendStrings.notifChannelId,
      SendStrings.notifChannelName,
      channelDescription: SendStrings.notifChannelDesc,
      importance: Importance.high,
      priority: Priority.high,
      icon: SendStrings.notifIconName,
    );
    await _plugin.show(
      0,
      SendStrings.notifSuccessTitle,
      SendStrings.notifSuccessBody,
      const NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(),
      ),
    );
  }
}
