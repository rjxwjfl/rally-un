class TodoEditModel {
  DateTime startDate;
  DateTime endDate;
  bool? isTimeSelected;

  // Repeat Type
  // 0 : normal, 1: daily, 2: weekly, 3: monthly, 4: yearly

  TodoEditModel({
    required this.startDate,
    required this.endDate,
    this.isTimeSelected = false,
  });

  @override
  String toString() {
    return 'TodoEditModel{startDate: $startDate, endDate: $endDate, isTimeSelected: $isTimeSelected}';
  }
}
