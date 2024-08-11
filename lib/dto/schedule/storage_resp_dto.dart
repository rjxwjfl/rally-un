import 'package:rally/util/datetime_convert.dart';

class StorageRespDto {
  int storageId;
  String title;
  int icon;
  int type;
  DateTime createdDate;
  DateTime updatedDate;

//<editor-fold desc="Data Methods">
  StorageRespDto({
    required this.storageId,
    required this.title,
    required this.icon,
    required this.type,
    required this.createdDate,
    required this.updatedDate,
  });

  factory StorageRespDto.fromMap(Map<String, dynamic> map) {
    return StorageRespDto(
      storageId: map['storage_id'] as int,
      title: map['title'] as String,
      icon: map['icon'] as int,
      type: map['type'] as int,
      createdDate: sqlToDateTime(map['created_date']),
      updatedDate: sqlToDateTime(map['updated_date']),
    );
  }

//</editor-fold>
}