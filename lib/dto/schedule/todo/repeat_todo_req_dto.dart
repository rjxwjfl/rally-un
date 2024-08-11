
import 'package:rally/dto/schedule/todo/replica_date_model.dart';
import 'package:rally/util/data_converter.dart';

class RepeatTodoReqDto {
  List<ReplicaDateModel> replica;
  bool repeatFlag;
  int? repeatType;
  int? frequency;
  List<int>? weekday;
  bool? allDayFlag;
  bool? todayFlag;
  bool? specFlag;

//<editor-fold desc="Data Methods">
  RepeatTodoReqDto({
    required this.replica,
    required this.repeatFlag,
    this.repeatType,
    this.frequency,
    this.weekday,
    this.allDayFlag,
    this.todayFlag,
    this.specFlag,
  });

  RepeatTodoReqDto copyWith({
    List<ReplicaDateModel>? replica,
    bool? repeatFlag,
    int? repeatType,
    int? frequency,
    List<int>? weekday,
    bool? allDayFlag,
    bool? todayFlag,
    bool? specFlag,
  }) {
    return RepeatTodoReqDto(
      replica: replica ?? this.replica,
      repeatFlag: repeatFlag ?? this.repeatFlag,
      repeatType: repeatType ?? this.repeatType,
      frequency: frequency ?? this.frequency,
      weekday: weekday ?? this.weekday,
      allDayFlag: allDayFlag ?? this.allDayFlag,
      todayFlag: todayFlag ?? this.todayFlag,
      specFlag: specFlag ?? this.specFlag,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'replica': replica.map((e) => e.toMap()).toList(),
      'repeatFlag': boolToInt(repeatFlag),
      'repeatType': repeatType,
      'frequency': frequency,
      'weekday': weekday,
      'alldayFlag': allDayFlag != null ? boolToInt(allDayFlag!) : null,
      'todayFlag': todayFlag != null ? boolToInt(todayFlag!) : null,
      'specFlag': specFlag != null ? boolToInt(specFlag!) : null,
    };
  }
//</editor-fold>
}