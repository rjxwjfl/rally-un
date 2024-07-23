class RepGenerateModel {
  String? description;
  DateTime scheduleStart;
  DateTime scheduleEnd;
  bool allDayFlag;
  bool todayFlag;
  bool specFlag;
  int? frequency;
  int? repeatType;
  List<int>? weekday;
  List<Duration>? reminders;

  RepGenerateModel({
    this.description,
    required this.scheduleStart,
    required this.scheduleEnd,
    required this.allDayFlag,
    required this.todayFlag,
    required this.specFlag,
    this.frequency,
    this.repeatType,
    this.weekday,
    this.reminders,
  });
}