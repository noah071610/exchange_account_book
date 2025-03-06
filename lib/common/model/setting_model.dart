import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'setting_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 4)
class SettingModel {
  @JsonKey()
  @HiveField(0)
  final int themeNum;

  @JsonKey()
  @HiveField(1)
  final String language;

  @JsonKey()
  @HiveField(2)
  final String font;

  @JsonKey()
  @HiveField(3)
  final String primaryColor;

  @JsonKey()
  @HiveField(4)
  final String subColor;

  SettingModel({
    required this.themeNum,
    required this.language,
    required this.font,
    required this.primaryColor,
    required this.subColor,
  });

  factory SettingModel.fromJson(Map<String, dynamic> json) =>
      _$SettingModelFromJson(json);

  Map<String, dynamic> toJson() => _$SettingModelToJson(this);

  SettingModel copyWith({
    String? language,
    String? font,
    int? themeNum,
    String? primaryColor,
    String? subColor,
  }) {
    return SettingModel(
      language: language ?? this.language,
      themeNum: themeNum ?? this.themeNum,
      font: font ?? this.font,
      primaryColor: primaryColor ?? this.primaryColor,
      subColor: subColor ?? this.subColor,
    );
  }
}
