import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../model/notification_model.dart';
import 'inotification_service.dart';

class NotificationService extends INotificationService {
  static final NotificationService _instance = NotificationService._init();
  final _notifications = FlutterLocalNotificationsPlugin();
  final onNotifications = BehaviorSubject<String?>();

  static NotificationService get instance => _instance;

  NotificationService._init();

  @override
  Future insertNotification(NotificationModel notification) async {
    _notifications.zonedSchedule(
        int.parse("${notification.countdownId}${notification.id}"),
        notification.title,
        notification.body,
        tz.TZDateTime.from(notification.scheduledDate, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            "channel id",
            "channel name",
            channelDescription: "channel description",
            importance: Importance.max,
          ),
          iOS: IOSNotificationDetails(),
        ),
        androidAllowWhileIdle: true,
        payload: notification.payload,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
  }

  @override
  Future<void> updateNotification(
      int id, String title, String body, DateTime scheduledDate, String payload) async {
    _notifications.zonedSchedule(
        id,
        title, //
        body, //
        tz.TZDateTime.from(scheduledDate, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            "channel id",
            "channel name",
            channelDescription: "channel description",
            importance: Importance.min,
          ),
          iOS: IOSNotificationDetails(),
        ),
        androidAllowWhileIdle: true,
        payload: payload, //
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
  }

  @override
  Future<List<PendingNotificationRequest?>> pendingNotifications() async {
    final pendingNotificationRequests = await _notifications.pendingNotificationRequests();
    return pendingNotificationRequests;
  }

  @override
  Future<void> init() async {
    final AndroidInitializationSettings android =
        // ignore: prefer_const_constructors
        AndroidInitializationSettings('@drawable/ic_stat_notification');
    // ignore: prefer_const_constructors
    final IOSInitializationSettings ios = IOSInitializationSettings();
    final InitializationSettings settings = InitializationSettings(android: android, iOS: ios);

    _configureLocalTimeZone();

    await _notifications.initialize(
      settings,
      onSelectNotification: (payload) async {
        onNotifications.add(payload);
      },
    );
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  @override
  Future<void> cancelNotification(int id) async {
    _notifications.cancel(id);
  }

  @override
  Future<void> cancelAllNotification(int id) async {
    for (var i = 0; i < 3; i++) {
      _notifications.cancel(int.parse('$id$i'));
    }
  }
}
