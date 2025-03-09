import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account_book_btn_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 6)
class AccountBookBtnModel {
  @JsonKey()
  @HiveField(0)
  final String label;

  @JsonKey()
  @HiveField(1)
  final String icon;

  @JsonKey()
  @HiveField(2)
  final String color;

  AccountBookBtnModel({
    required this.label,
    required this.icon,
    required this.color,
  });

  factory AccountBookBtnModel.fromJson(Map<String, dynamic> json) =>
      _$AccountBookBtnModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountBookBtnModelToJson(this);

  AccountBookBtnModel copyWith({
    String? label,
    String? icon,
    String? color,
    bool? favorite,
  }) {
    return AccountBookBtnModel(
      label: label ?? this.label,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }
}
