part of 'notifications_bloc.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

class NotificationStatusChanged extends NotificationsEvent {
  final AuthorizationStatus status;

  const NotificationStatusChanged({required this.status});
}

class NotificationRecived extends NotificationsEvent {
  final PushMessage notification;

  const NotificationRecived({required this.notification});
}
