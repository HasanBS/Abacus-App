import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
  final int id;
  final int countdownId;
  final String title;
  final String body;
  final DateTime scheduledDate;
  String? payload;

  NotificationModel(
    this.payload, {
    required this.id,
    required this.countdownId,
    required this.title,
    required this.body,
    required this.scheduledDate,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
