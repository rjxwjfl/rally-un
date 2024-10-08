import 'package:rally/dto/user/todo_author.dart';
import 'package:rally/util/datetime_convert.dart';

class TodoRespDto {
  int todoId;
  AuthorRespDto author;
  String title;
  String? desc;
  int priority;
  int state;
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
      state: map['state'] as int,
      startDate: sqlToDateTime(map['start_date']),
      endDate: sqlToDateTime(map['end_date']),
      completeDate: map['complete_date'] != null ? sqlToDateTime(map['complete_date']) : null,
      createdDate: sqlToDateTime(map['created_date']),
      updatedDate: sqlToDateTime(map['updated_date']),
    );
  }

//</editor-fold>
}
