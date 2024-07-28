class TodoEditModel {
  DateTime startDate;
  DateTime endDate;
  bool isRepeat;
  int repeatType;
  int frequency;
  List<int> weekday;
  bool isSpecDay;
  // Repeat Type
  // 0 : normal, 1: daily, 2: weekly, 3: monthly, 4: yearly

  TodoEditModel({
    required this.startDate,
    required this.endDate,
    required this.isRepeat,
    required this.repeatType,
    required this.frequency,
    required this.weekday,
    required this.isSpecDay,
  });
}