import 'package:rally/configs/object_box_entity/repeat_model.dart';

class TodoModel {
  int id;
  String title;
  int priority;
  DateTime createdDate;
  DateTime updatedDate;
  List<TodoComponent> todoComponents;
  bool repeatFlag;
  int? repeatType;
  int? frequency;
  List<int>? weekday;
  bool? allDayFlag;
  bool? todayFlag;
  bool? specFlag;
}
