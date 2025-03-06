import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'package:flutter/material.dart';

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

  @JsonKey()
  @HiveField(3)
  final bool favorite;

  AccountBookBtnModel({
    required this.label,
    required this.icon,
    required this.color,
    required this.favorite,
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
      favorite: favorite ?? this.favorite,
    );
  }
}
