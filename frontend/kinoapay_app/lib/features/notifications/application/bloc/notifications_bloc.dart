import "package:flutter_bloc/flutter_bloc.dart";
import "package:kinoapay_app/features/notifications/application/bloc/notifications_event.dart";
import "package:kinoapay_app/features/notifications/application/bloc/notifications_state.dart";
import "package:kinoapay_app/features/notifications/domain/repositories/notifications_repository.dart";

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationsRepository _repository;

  NotificationsBloc({required NotificationsRepository repository})
      : _repository = repository,
        super(const NotificationsInitial()) {
    on<NotificationsStarted>(_onStarted);
    on<NotificationMarkedRead>(_onMarkedRead);
    on<NotificationsAllMarkedRead>(_onAllMarkedRead);
  }

  Future<void> _onStarted(
    NotificationsStarted event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(const NotificationsLoading());
    try {
      final notifications = await _repository.getNotifications();
      emit(NotificationsLoadSuccess(notifications));
    } catch (_) {
      emit(const NotificationsError("Impossible de charger les notifications."));
    }
  }

  Future<void> _onMarkedRead(
    NotificationMarkedRead event,
    Emitter<NotificationsState> emit,
  ) async {
    final current = state;
    if (current is! NotificationsLoadSuccess) return;

    await _repository.markAsRead(event.id);

    final updated = current.notifications.map((n) {
      return n.id == event.id ? n.markRead() : n;
    }).toList();

    emit(NotificationsLoadSuccess(updated));
  }

  Future<void> _onAllMarkedRead(
    NotificationsAllMarkedRead event,
    Emitter<NotificationsState> emit,
  ) async {
    final current = state;
    if (current is! NotificationsLoadSuccess) return;

    await _repository.markAllAsRead();

    final updated = current.notifications
        .map((n) => n.isRead ? n : n.markRead())
        .toList();

    emit(NotificationsLoadSuccess(updated));
  }
}
