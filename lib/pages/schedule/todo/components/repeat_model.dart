class RepeatModel {
  int frequency;
  int currentType;
  List<int> selectedWeekday;
  bool isSpecDay;

  RepeatModel({
    required this.frequency,
    required this.currentType,
    required this.selectedWeekday,
    required this.isSpecDay,
  });

  RepeatModel copyWith({
    int? frequency,
    int? currentType,
    List<int>? selectedWeekday,
    bool? isSpecDay,
  }) {
    return RepeatModel(
      frequency: frequency ?? this.frequency,
      currentType: currentType ?? this.currentType,
      selectedWeekday: selectedWeekday ?? this.selectedWeekday,
      isSpecDay: isSpecDay ?? this.isSpecDay,
    );
  }
}
