import 'package:rally/util/datetime_convert.dart';

class TodoReqDto {
  String title;
  String? desc;
  int priority;
  int state;
  DateTime startDate;
  DateTime endDate;
  DateTime? completedDate;

  TodoReqDto({
    required this.title,
    this.desc,
    required this.priority,
    required this.state,
    required this.startDate,
    required this.endDate,
    this.completedDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'desc': desc,
      'priority': priority,
      'state': state,
      'start_date': sqlDateFormat(startDate),
      'end_date': sqlDateFormat(endDate),
      'completed_date': completedDate != null ? sqlDateFormat(completedDate!) : null,
    };
  }

  TodoReqDto copyWith({
    String? title,
    String? desc,
    int? priority,
    int? state,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? completedDate,
  }) {
    return TodoReqDto(
      title: title ?? this.title,
      desc: desc ?? this.desc,
      priority: priority ?? this.priority,
      state: state ?? this.state,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      completedDate: completedDate ?? this.completedDate,
    );
  }
}