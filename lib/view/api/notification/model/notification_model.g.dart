// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) {
  return NotificationModel(
    json['payload'] as String?,
    id: json['id'] as int,
    countdownId: json['countdownId'] as int,
    title: json['title'] as String,
    body: json['body'] as String,
    scheduledDate: DateTime.parse(json['scheduledDate'] as String),
  );
}

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'countdownId': instance.countdownId,
      'title': instance.title,
      'body': instance.body,
      'scheduledDate': instance.scheduledDate.toIso8601String(),
      'payload': instance.payload,
    };
