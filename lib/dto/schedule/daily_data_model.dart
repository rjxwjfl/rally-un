import 'package:rally/dto/schedule/schedule_resp_dto.dart';
import 'package:rally/dto/schedule/todo/todo_resp_dto.dart';

class DailyDataModel {
  List<ScheduleRespDto> schedule;
  List<TodoRespDto> todo;

  DailyDataModel({
    required this.schedule,
    required this.todo,
  });
}