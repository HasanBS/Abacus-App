part of 'notification_cubit.dart';

abstract class NotificationState {
  const NotificationState();
}

class NotificationInitial extends NotificationState {}

class NotificationLoadSucces extends NotificationState {
  final List<PendingNotificationRequest?> notificationList;

  const NotificationLoadSucces(this.notificationList);
}
