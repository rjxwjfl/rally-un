import 'dart:io';
import 'dart:ui';

import 'package:rally/dto/schedule/todo/internal_todo_resp_dto.dart';

Map<DateTime, List<InternalTodoRespDto>> todoDataFormer(List<InternalTodoRespDto>? data) {
  Map<DateTime, List<InternalTodoRespDto>> map = {};

  if (data != null) {
    for (InternalTodoRespDto todo in data) {
      DateTime date = todo.startDate;
      DateTime dateKey = DateTime(date.year, date.month, date.day);

      map.putIfAbsent(dateKey, () => []).add(todo);
    }
  }
  return map;
}

Locale getLocale() {
  String localeName = Platform.localeName;
  List<String> parts = localeName.split('_');
  if (parts.length == 2) {
    return Locale(parts[0], parts[1]);
  } else {
    return Locale(parts[0]);
  }
}
