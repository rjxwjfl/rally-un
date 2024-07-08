import 'package:rally/model/user/todo_author.dart';
import 'package:rally/util/datetime_convert.dart';
import 'package:rally/util/todo_state.dart';

class TodoModel {
  int todoId;
  TodoAuthor author;
  String title;
  String? desc;
  TodoState state;
  DateTime? completeDate;
  DateTime createdDate;
  DateTime updatedDate;

//<editor-fold desc="Data Methods">
  TodoModel({
    required this.todoId,
    required this.author,
    required this.title,
    this.desc,
    required this.state,
    this.completeDate,
    required this.createdDate,
    required this.updatedDate,
  });

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      todoId: map['todo_id'] as int,
      author: TodoAuthor.fromMap(map['author']),
      title: map['title'] as String,
      desc: map['desc'] != null ? map['desc'] as String : null,
      state: intToState(map['state']),
      completeDate: map['complete_date'] != null ? sqlToDateTime(map['complete_date']) : null,
      createdDate: sqlToDateTime(map['created_date']),
      updatedDate: sqlToDateTime(map['updated_date']),
    );
  }

//</editor-fold>
}
