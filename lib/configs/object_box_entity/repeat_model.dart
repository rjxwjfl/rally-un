import 'package:rally/configs/object_box_entity/coord.dart';

class TodoComponent {
  int id;
  String? desc;
  Coord? coord;
  int state;
  DateTime startDate;
  DateTime endDate;
  DateTime completedDate;

//<editor-fold desc="Data Methods">
  TodoComponent({
    required this.id,
    this.desc,
    this.coord,
    required this.state,
    required this.startDate,
    required this.endDate,
    required this.completedDate,
  });

  TodoComponent copyWith({
    int? id,
    String? desc,
    Coord? coord,
    int? state,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? completedDate,
  }) {
    return TodoComponent(
      id: id ?? this.id,
      desc: desc ?? this.desc,
      coord: coord ?? this.coord,
      state: state ?? this.state,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      completedDate: completedDate ?? this.completedDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'desc': desc,
      'coord': coord,
      'state': state,
      'startDate': startDate,
      'endDate': endDate,
      'completedDate': completedDate,
    };
  }

  factory TodoComponent.fromMap(Map<String, dynamic> map) {
    return TodoComponent(
      id: map['id'] as int,
      desc: map['desc'] != null ? map['desc'] as String : null,
      coord: map['coord'] != null ? Coord.fromMap(map['coord']) : null,
      state: map['state'] as int,
      startDate: map['startDate'] as DateTime,
      endDate: map['endDate'] as DateTime,
      completedDate: map['completedDate'] as DateTime,
    );
  }

//</editor-fold>
}