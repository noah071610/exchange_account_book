import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'exchange_rate_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 22)
class ExchangeRateModel {
  @JsonKey()
  @HiveField(0)
  final Map<String, double> map;

  ExchangeRateModel({
    required this.map,
  });

  factory ExchangeRateModel.fromJson(Map<String, dynamic> json) =>
      _$ExchangeRateModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExchangeRateModelToJson(this);

  ExchangeRateModel copyWith({
    Map<String, double>? map,
  }) {
    return ExchangeRateModel(
      map: map ?? this.map,
    );
  }
}
