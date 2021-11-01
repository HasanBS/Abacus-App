import '../../../../core/init/database/idatabase_model.dart';

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

  CountdownModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    title = json['title'] as String;
    description = json['description'] as String;
    goalDate = json['goalDate'] as String;
    createDate = json['createDate'] as String;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['goalDate'] = goalDate;
    data['createDate'] = createDate;
    return data;
  }

  @override
  CountdownModel fromJson(Map<String, dynamic> json) {
    return CountdownModel.fromJson(json);
  }
}
