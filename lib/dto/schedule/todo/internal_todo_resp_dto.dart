import 'package:rally/util/datetime_convert.dart';

class InternalTodoRespDto {
  int todoId;
  String title;
  String? desc;
  int priority;
  int state;
  DateTime startDate;
  DateTime endDate;
  DateTime? completeDate;
  DateTime createdDate;
  DateTime updatedDate;
  String storageTitle;
  int icon;
  int type;
  DateTime storageCreatedDate;
  DateTime storageUpdatedDate;

  //<editor-fold desc="Data Methods">
  InternalTodoRespDto({
    required this.todoId,
    required this.title,
    this.desc,
    required this.priority,
    required this.state,
    required this.startDate,
    required this.endDate,
    this.completeDate,
    required this.createdDate,
    required this.updatedDate,
    required this.storageTitle,
    required this.icon,
    required this.type,
    required this.storageCreatedDate,
    required this.storageUpdatedDate,
  });

  factory InternalTodoRespDto.fromMap(Map<String, dynamic> map) {
    return InternalTodoRespDto(
      todoId: map['todo_id'] as int,
      title: map['title'] as String,
      desc: map['desc'] != null ? map['desc'] as String : null,
      priority: map['priority'] as int,
      state: map['state'] as int,
      startDate: sqlToDateTime(map['start_date']),
      endDate: sqlToDateTime(map['end_date']),
      completeDate: map['complete_date'] != null ? sqlToDateTime(map['complete_date']) : null,
      createdDate: sqlToDateTime(map['created_date']),
      updatedDate: sqlToDateTime(map['updated_date']),
      storageTitle: map['storage_title'] as String,
      icon: map['icon'] as int,
      type: map['type'] as int,
      storageCreatedDate: sqlToDateTime(map['storage_created_date']),
      storageUpdatedDate: sqlToDateTime(map['storage_updated_date']),
    );
  }

//</editor-fold>
}
