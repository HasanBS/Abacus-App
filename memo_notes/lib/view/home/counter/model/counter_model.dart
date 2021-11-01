import '../../../../core/init/database/idatabase_model.dart';

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
  CounterModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    title = json['title'] as String;
    description = json['description'] as String;
    counterTotal = json['counterTotal'] as double;
    counterRatio = json['counterRatio'] as double;
    createDate = json['createDate'] as String;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['counterTotal'] = counterTotal;
    data['counterRatio'] = counterRatio;
    data['createDate'] = createDate;
    return data;
  }

  @override
  CounterModel fromJson(Map<String, dynamic> json) {
    return CounterModel.fromJson(json);
  }
}
