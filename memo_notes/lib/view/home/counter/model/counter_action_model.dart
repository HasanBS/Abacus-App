import '../../../../core/init/database/idatabase_model.dart';

class CounterActionModel extends IDatabaseModel<CounterActionModel> {
  late int? id;
  late int counterId; //FK
  late int isPositive; //0 means false (-) 1 means true (+)
  late double actionTotal;
  late double actionAmount;
  late String actionDate;

  CounterActionModel({
    this.id,
    String? actionDate,
    required this.counterId,
    required this.isPositive,
    required this.actionTotal,
    required this.actionAmount,
  }) : actionDate = actionDate ?? DateTime.now().toString();

  CounterActionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int;
    counterId = json['counterId'] as int;
    isPositive = json['isPositive'] as int;
    actionTotal = json['actionTotal'] as double;
    actionAmount = json['actionAmount'] as double;
    actionDate = json['actionDate'] as String;
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['counterId'] = counterId;
    data['isPositive'] = isPositive;
    data['actionTotal'] = actionTotal;
    data['actionAmount'] = actionAmount;
    data['actionDate'] = actionDate;
    return data;
  }

  @override
  CounterActionModel fromJson(Map<String, dynamic> json) {
    return CounterActionModel.fromJson(json);
  }
}
