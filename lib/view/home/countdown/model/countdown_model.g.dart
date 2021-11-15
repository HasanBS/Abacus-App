// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'countdown_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountdownModel _$CountdownModelFromJson(Map<String, dynamic> json) {
  return CountdownModel(
    id: json['id'] as int?,
    title: json['title'] as String,
    description: json['description'] as String?,
    goalDate: json['goalDate'] as String,
    createDate: json['createDate'] as String?,
  );
}

Map<String, dynamic> _$CountdownModelToJson(CountdownModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'goalDate': instance.goalDate,
      'createDate': instance.createDate,
    };
