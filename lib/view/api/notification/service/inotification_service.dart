import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../model/notification_model.dart';

abstract class INotificationService {
  Future<List<PendingNotificationRequest?>> pendingNotifications();
  Future<void> insertNotification(NotificationModel notification);
  Future<void> updateNotification(
      int id, String title, String body, DateTime scheduledDate, String payload);
  Future<void> cancelNotification(int id);
  Future<void> cancelAllNotification(int id);
  Future<void> init();
}
