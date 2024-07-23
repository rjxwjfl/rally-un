import 'package:rally/dto/schedule/schedule_resp_dto.dart';
import 'package:rally/dto/schedule/todo/todo_resp_dto.dart';

class DailyDataRespDto {
  List<ScheduleRespDto>? schedule;
  List<TodoRespDto>? todo;

//<editor-fold desc="Data Methods">
  DailyDataRespDto({
    this.schedule,
    this.todo,
  });

  factory DailyDataRespDto.fromMap(Map<String, dynamic> map) {
    List<dynamic> sch = map['schedule'] ?? [];
    List<dynamic> td = map['todo'] ?? [];

    return DailyDataRespDto(
      schedule: sch.map((e) => ScheduleRespDto.fromMap(e)).toList(),
      todo: td.map((e) => TodoRespDto.fromMap(e)).toList(),
    );
  }

//</editor-fold>
}
