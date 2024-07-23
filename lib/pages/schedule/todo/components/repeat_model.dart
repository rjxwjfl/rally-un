class RepeatModel {
  int frequency;
  int currentType;
  List<int>? selectedWeekday;
  List<bool>? weekdayFlag;
  DateTime scheduleEnd;
  bool? isDay;

  RepeatModel({
    required this.frequency,
    required this.currentType,
    this.selectedWeekday,
    this.weekdayFlag,
    required this.scheduleEnd,
    this.isDay,
  });

  RepeatModel copyWith({
    int? frequency,
    int? currentType,
    List<int>? selectedWeekday,
    List<bool>? weekdayFlag,
    DateTime? scheduleEnd,
    bool? isDay,
  }) {
    return RepeatModel(
      frequency: frequency ?? this.frequency,
      currentType: currentType ?? this.currentType,
      selectedWeekday: selectedWeekday ?? this.selectedWeekday,
      weekdayFlag: weekdayFlag ?? this.weekdayFlag,
      scheduleEnd: scheduleEnd ?? this.scheduleEnd,
      isDay: isDay ?? this.isDay,
    );
  }
}
