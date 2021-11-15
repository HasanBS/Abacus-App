// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'counter_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CounterModel _$CounterModelFromJson(Map<String, dynamic> json) {
  return CounterModel(
    id: json['id'] as int?,
    createDate: json['createDate'] as String?,
    title: json['title'] as String,
    description: json['description'] as String?,
    counterTotal: (json['counterTotal'] as num).toDouble(),
    counterRatio: (json['counterRatio'] as num).toDouble(),
  );
}

Map<String, dynamic> _$CounterModelToJson(CounterModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'counterTotal': instance.counterTotal,
      'counterRatio': instance.counterRatio,
      'createDate': instance.createDate,
    };
