class StorageReqDto {
  String title;
  int icon;
  int type;

//<editor-fold desc="Data Methods">
  StorageReqDto({
    required this.title,
    required this.icon,
    required this.type,
  });

  StorageReqDto copyWith({
    String? title,
    int? icon,
    int? type,
  }) {
    return StorageReqDto(
      title: title ?? this.title,
      icon: icon ?? this.icon,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'icon': icon,
      'type': type,
    };
  }
//</editor-fold>
}