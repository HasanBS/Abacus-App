import 'package:json_annotation/json_annotation.dart';

import '../../../../core/init/database/idatabase_model.dart';

part 'todo_model.g.dart';

@JsonSerializable()
class TodoModel extends IDatabaseModel<TodoModel> {
  int? id;
  late String title;
  String? description;
  late int isDone;
  late String createDate;
  String? doneDate;

  TodoModel({
    this.id,
    required this.title,
    this.description,
    int? isDone,
    String? createDate,
    this.doneDate,
  })  : isDone = isDone ?? 0,
        createDate = createDate ?? DateTime.now().toString();

  factory TodoModel.fromJson(Map<String, dynamic> json) => _$TodoModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TodoModelToJson(this);

  @override
  TodoModel fromJson(Map<String, dynamic> json) {
    return TodoModel.fromJson(json);
  }
}
