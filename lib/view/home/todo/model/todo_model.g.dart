// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoModel _$TodoModelFromJson(Map<String, dynamic> json) {
  return TodoModel(
    id: json['id'] as int?,
    title: json['title'] as String,
    description: json['description'] as String?,
    isDone: json['isDone'] as int?,
    createDate: json['createDate'] as String?,
    doneDate: json['doneDate'] as String?,
  );
}

Map<String, dynamic> _$TodoModelToJson(TodoModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'isDone': instance.isDone,
      'createDate': instance.createDate,
      'doneDate': instance.doneDate,
    };
