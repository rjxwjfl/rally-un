import 'package:rally/dto/user/todo_author.dart';
import 'package:rally/util/data_converter.dart';
import 'package:rally/util/datetime_convert.dart';
import 'package:rally/util/todo_state.dart';

class TodoRespDto {
  int todoId;
  AuthorRespDto author;
  String title;
  String? desc;
  int priority;
  bool setTimeFlag;
  TodoState state;
  DateTime startDate;
  DateTime endDate;
  DateTime? completeDate;
  DateTime createdDate;
  DateTime updatedDate;

//<editor-fold desc="Data Methods">
  TodoRespDto({
    required this.todoId,
    required this.author,
    required this.title,
    this.desc,
    required this.priority,
    required this.setTimeFlag,
    required this.state,
    required this.startDate,
    required this.endDate,
    this.completeDate,
    required this.createdDate,
    required this.updatedDate,
  });

  factory TodoRespDto.fromMap(Map<String, dynamic> map) {
    return TodoRespDto(
      todoId: map['todo_id'] as int,
      author: AuthorRespDto.fromMap(map['author']),
      title: map['title'] as String,
      desc: map['desc'] != null ? map['desc'] as String : null,
      priority: map['priority'] as int,
      setTimeFlag: intToBool(map['set_time_flag']),
      state: intToState(map['state']),
      startDate: sqlToDateTime(map['start_date']),
      endDate: sqlToDateTime(map['end_date']),
      completeDate: map['complete_date'] != null ? sqlToDateTime(map['complete_date']) : null,
      createdDate: sqlToDateTime(map['created_date']),
      updatedDate: sqlToDateTime(map['updated_date']),
    );
  }

//</editor-fold>
}
