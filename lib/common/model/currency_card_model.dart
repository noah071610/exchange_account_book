import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'currency_card_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 28)
class CurrencyCardModel {
  @JsonKey()
  @HiveField(0)
  final String name;

  @JsonKey()
  @HiveField(1)
  final double amount;

  CurrencyCardModel({
    required this.name,
    required this.amount,
  });

  factory CurrencyCardModel.fromJson(Map<String, dynamic> json) =>
      _$CurrencyCardModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyCardModelToJson(this);

  CurrencyCardModel copyWith({
    String? name,
    double? amount,
  }) {
    return CurrencyCardModel(
      name: name ?? this.name,
      amount: amount ?? this.amount,
    );
  }
}
