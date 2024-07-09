import 'dart:convert';

import 'package:rally/dto/schedule/todo/todo_resp_dto.dart';
import 'package:rally/util/data_converter.dart';
import 'package:rally/util/datetime_convert.dart';

class ScheduleRespDto {
  int schId;
  String title;
  String? desc;
  DateTime startDate;
  DateTime? endDate;
  DateTime createdDate;
  DateTime updatedDate;
  List<TodoRespDto>? data;
  bool repeatFlag;
  // Repeat Type
  // 0: none, 1: daily, 2: weekly, 3: monthly, 4: yearly
  int repeatType;
  bool specFlag;
  int frequency;
  List<int>? weekday;
  bool allDayFlag;
  bool todayFlag;

//<editor-fold desc="Data Methods">
  ScheduleRespDto({
    required this.schId,
    required this.title,
    this.desc,
    required this.startDate,
    this.endDate,
    required this.createdDate,
    required this.updatedDate,
    this.data,
    required this.repeatFlag,
    required this.repeatType,
    required this.specFlag,
    required this.frequency,
    this.weekday,
    required this.allDayFlag,
    required this.todayFlag,
  });

  factory ScheduleRespDto.fromMap(Map<String, dynamic> map) {
    List<dynamic> todoData = map['data']?? [];
    String? weekday = map['weekday'];
    List<int>? weekdayList;

    if (weekday != null){
      weekdayList = base64Decode(weekday.split(':')[2]);
    }

    return ScheduleRespDto(
      schId: map['sch_id'] as int,
      title: map['title'] as String,
      desc: map['desc'] != null ? map['desc'] as String : null,
      startDate: sqlToDateTime(map['start_date']),
      endDate: map['end_date'] != null ? sqlToDateTime(map['end_date']) : null,
      createdDate: sqlToDateTime(map['created_date']),
      updatedDate: sqlToDateTime(map['updated_date']),
      data: todoData.map((e) => TodoRespDto.fromMap(e)).toList(),
      repeatFlag: intToBool(map['repeat_flag']),
      repeatType: map['repeat_type'] as int,
      specFlag: intToBool(map['spec_flag']),
      frequency: map['frequency'] as int,
      weekday: weekdayList,
      allDayFlag: intToBool(map['allday_flag']),
      todayFlag: intToBool(map['today_flag']),
    );
  }

//</editor-fold>
}