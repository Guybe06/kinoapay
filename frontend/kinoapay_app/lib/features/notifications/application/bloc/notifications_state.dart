import "package:equatable/equatable.dart";
import "package:kinoapay_app/features/notifications/domain/entities/notification_record.dart";

abstract class NotificationsState extends Equatable {
  const NotificationsState();
  @override
  List<Object?> get props => [];
}

class NotificationsInitial extends NotificationsState {
  const NotificationsInitial();
}

class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

class NotificationsLoadSuccess extends NotificationsState {
  final List<KinoaNotification> notifications;

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  const NotificationsLoadSuccess(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

class NotificationsError extends NotificationsState {
  final String message;
  const NotificationsError(this.message);
  @override
  List<Object?> get props => [message];
}
