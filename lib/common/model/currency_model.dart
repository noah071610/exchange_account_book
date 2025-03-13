import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'currency_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 3)
class CurrencyModel {
  @JsonKey()
  @HiveField(0)
  final String name;

  @JsonKey()
  @HiveField(1)
  final String countryCode;

  @JsonKey()
  @HiveField(2)
  final String currencyCode;

  @JsonKey()
  @HiveField(3)
  final String currencySymbol;

  @JsonKey()
  @HiveField(4)
  final String continent;

  CurrencyModel({
    required this.name,
    required this.countryCode,
    required this.currencyCode,
    required this.currencySymbol,
    required this.continent,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) =>
      _$CurrencyModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyModelToJson(this);

  CurrencyModel copyWith({
    String? name,
    String? countryCode,
    String? currencyCode,
    String? currencySymbol,
    String? continent,
  }) {
    return CurrencyModel(
      name: name ?? this.name,
      countryCode: countryCode ?? this.countryCode,
      currencyCode: currencyCode ?? this.currencyCode,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      continent: continent ?? this.continent,
    );
  }
}
