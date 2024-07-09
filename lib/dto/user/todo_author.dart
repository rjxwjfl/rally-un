import 'package:rally/util/data_converter.dart';
import 'package:rally/util/datetime_convert.dart';

class TodoAuthorRespDto {
  int userId;
  String username;
  String displayName;
  String? userImage;
  String? contact;
  String? introduction;
  bool privateFlag;
  DateTime latestAccess;

//<editor-fold desc="Data Methods">
  TodoAuthorRespDto({
    required this.userId,
    required this.username,
    required this.displayName,
    this.userImage,
    this.contact,
    this.introduction,
    required this.privateFlag,
    required this.latestAccess,
  });

  factory TodoAuthorRespDto.fromMap(Map<String, dynamic> map) {
    return TodoAuthorRespDto(
      userId: map['user_id'] as int,
      username: map['username'] as String,
      displayName: map['display_name'] as String,
      userImage: map['user_image'] != null ? map['user_image'] as String : null,
      contact: map['contact'] != null ? map['contact'] as String : null,
      introduction: map['introduction'] != null ? map['introduction'] as String : null,
      privateFlag: intToBool(map['private_flag']),
      latestAccess: sqlToDateTime(map['latest_access']),
    );
  }

//</editor-fold>
}