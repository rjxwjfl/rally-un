import 'package:rally/util/datetime_convert.dart';

class ReplicaDateModel {
  DateTime startDate;
  DateTime endDate;
  List<DateTime>? activeDate;

//<editor-fold desc="Data Methods">
  ReplicaDateModel({
    required this.startDate,
    required this.endDate,
    this.activeDate,
  });

  ReplicaDateModel copyWith({
    DateTime? executionDate,
    DateTime? expirationDate,
    List<DateTime>? activeDate,
  }) {
    return ReplicaDateModel(
      startDate: executionDate ?? startDate,
      endDate: expirationDate ?? endDate,
      activeDate: activeDate ?? this.activeDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'start_date': sqlDateFormat(startDate),
      'end_date': sqlDateFormat(endDate),
      'active_date': activeDate?.map((e) => sqlDateFormat(e)).toList(),
    };
  }
//</editor-fold>
}
