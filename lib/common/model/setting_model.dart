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

  @JsonKey()
  @HiveField(5)
  final List<String> selectedCountriesForCalender;

  @JsonKey()
  @HiveField(6)
  final String selectCountryForAnalytics;

  SettingModel({
    required this.themeNum,
    required this.language,
    required this.font,
    required this.primaryColor,
    required this.subColor,
    required this.selectedCountriesForCalender,
    required this.selectCountryForAnalytics,
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
    List<String>? selectedCountriesForCalender,
    String? selectCountryForAnalytics,
  }) {
    return SettingModel(
      language: language ?? this.language,
      themeNum: themeNum ?? this.themeNum,
      font: font ?? this.font,
      primaryColor: primaryColor ?? this.primaryColor,
      subColor: subColor ?? this.subColor,
      selectedCountriesForCalender:
          selectedCountriesForCalender ?? this.selectedCountriesForCalender,
      selectCountryForAnalytics:
          selectCountryForAnalytics ?? this.selectCountryForAnalytics,
    );
  }
}
