import 'package:rally/util/data_converter.dart';

class UserDataRespDto {
  int userId;
  String uuid;
  String deviceToken;
  String displayName;
  String? contact;
  String? imageUrl;
  String? introduction;
  bool privateFlag;
  DateTime latestAccess;

//<editor-fold desc="Data Methods">
  UserDataRespDto({
    required this.userId,
    required this.uuid,
    required this.deviceToken,
    required this.displayName,
    this.contact,
    this.imageUrl,
    this.introduction,
    required this.privateFlag,
    required this.latestAccess,
  });

  factory UserDataRespDto.fromMap(Map<String, dynamic> map) {
    return UserDataRespDto(
      userId: map['user_id'] as int,
      uuid: map['uuid'] as String,
      deviceToken: map['device_token'] as String,
      displayName: map['display_name'] as String,
      contact: map['contact'] != null ? map['contact'] as String : null,
      imageUrl: map['image_url'] != null ? map['image_url'] as String : null,
      introduction: map['introduction'] != null ? map['introduction'] as String : null,
      privateFlag: intToBool(map['private_flag']),
      latestAccess: DateTime.parse(map['latest_access']),
    );
  }
}