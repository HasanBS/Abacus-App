import 'package:json_annotation/json_annotation.dart';

import '../../../../core/init/database/idatabase_model.dart';

part 'countdown_model.g.dart';

@JsonSerializable()
class CountdownModel extends IDatabaseModel<CountdownModel> {
  int? id;
  late String title;
  String? description;
  late String goalDate;
  late String createDate;

  CountdownModel({
    this.id,
    required this.title,
    this.description,
    required this.goalDate,
    String? createDate,
  }) : createDate = createDate ?? DateTime.now().toString();

  factory CountdownModel.fromJson(Map<String, dynamic> json) => _$CountdownModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CountdownModelToJson(this);

  @override
  CountdownModel fromJson(Map<String, dynamic> json) {
    return CountdownModel.fromJson(json);
  }
}
