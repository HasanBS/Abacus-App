import '../../../../core/init/database/idatabase_model.dart';

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

  TodoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    title = json['title'] as String;
    description = json['description'] as String;
    isDone = json['isDone'] as int;
    createDate = json['createDate'] as String;
    doneDate = (json['doneDate'] ?? '') as String;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['isDone'] = isDone;
    data['createDate'] = createDate;
    data['doneDate'] = doneDate;
    return data;
  }

  @override
  TodoModel fromJson(Map<String, dynamic> json) {
    return TodoModel.fromJson(json);
  }
}
