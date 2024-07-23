import 'package:rally/dto/schedule/todo/todo_resp_dto.dart';

Map<DateTime, List<TodoRespDto>> todoDataFormer(List<TodoRespDto>? data) {
  Map<DateTime, List<TodoRespDto>> map = {};

  if (data != null) {
    for (TodoRespDto todo in data) {
      DateTime date = todo.startDate;
      DateTime dateKey = DateTime(date.year, date.month, date.day);

      map.putIfAbsent(dateKey, () => []).add(todo);
    }
  }
  return map;
}
