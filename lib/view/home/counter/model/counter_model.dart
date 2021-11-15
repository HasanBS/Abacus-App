import 'package:json_annotation/json_annotation.dart';

import '../../../../core/init/database/idatabase_model.dart';

part 'counter_model.g.dart';

@JsonSerializable()
class CounterModel extends IDatabaseModel<CounterModel> {
  //extends DatabaseModel <Counter>
  int? id;
  late String title;
  String? description;
  late double counterTotal;
  late double counterRatio;
  late String createDate;

  CounterModel(
      {this.id,
      String? createDate,
      required this.title,
      this.description,
      required this.counterTotal,
      required this.counterRatio})
      : createDate = createDate ?? DateTime.now().toString();

  @override
  factory CounterModel.fromJson(Map<String, dynamic> json) => _$CounterModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CounterModelToJson(this);

  @override
  CounterModel fromJson(Map<String, dynamic> json) {
    return CounterModel.fromJson(json);
  }
}
