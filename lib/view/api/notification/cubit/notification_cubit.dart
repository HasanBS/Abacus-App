import 'package:bloc/bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../../core/extension/duration_extension.dart';
import '../model/notification_model.dart';
import '../service/notification_service.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit() : super(NotificationInitial());

  final _notificationProvider = NotificationService.instance;

  Future<void> getNotifications(int countdownId) async {
    final _pendingList = await _notificationProvider.pendingNotifications();
    final updatedNotificationList = _pendingList.where((element) {
      String sId = element!.id.toString();
      sId = sId.substring(0, sId.length - 1);
      if (int.parse(sId) == countdownId) {
        return true;
      }
      return false;
    }).toList();
    emit(NotificationLoadSucces(updatedNotificationList));
  }

  int notificationLengt() {
    if (state is NotificationLoadSucces) {
      return (state as NotificationLoadSucces).notificationList.length;
    } else {
      return 0;
    }
  }

  Future<void> insertNotification(
      int countdownId, String title, String body, DateTime reminderDate) async {
    if ((state as NotificationLoadSucces).notificationList.length < 3) {
      late int insertId;
      if ((state as NotificationLoadSucces).notificationList.isNotEmpty) {
        for (var i = 0; i < 3; i++) {
          if (!(state as NotificationLoadSucces)
              .notificationList
              .any((element) => element!.id == int.parse("$countdownId$i"))) {
            insertId = i;
            break;
          }
        }
      } else {
        insertId = 0;
      }

      final notiModel = NotificationModel(reminderDate.stringDate,
          id: insertId,
          countdownId: countdownId,
          title: title,
          body: body,
          scheduledDate: reminderDate);
      final newNotification = PendingNotificationRequest(
          int.parse("$countdownId$insertId"), title, body, reminderDate.stringDate);
      final notiList = (state as NotificationLoadSucces).notificationList;
      notiList.add(newNotification);

      emit(NotificationLoadSucces(notiList));
      _notificationProvider.insertNotification(notiModel);
    }
  }

  Future<void> updateNotification(int id, String title, String body, DateTime scheduledDate) async {
    _notificationProvider.updateNotification(
        id, title, body, scheduledDate, scheduledDate.stringDate);
    final notiList = (state as NotificationLoadSucces).notificationList;
    final newNotification = PendingNotificationRequest(id, title, body, scheduledDate.stringDate);
    notiList.removeWhere((element) => element!.id == id);
    notiList.add(newNotification);
    emit(NotificationLoadSucces(notiList));
  }

  Future<void> cancelNotification(int id) async {
    _notificationProvider.cancelNotification(id);
    final notiList = (state as NotificationLoadSucces).notificationList;
    notiList.removeWhere((element) => element!.id == id);
    emit(NotificationLoadSucces(notiList));
  }
}
