import 'package:currency_exchange/common/model/currency_model.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'currency_pair_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 2)
class CurrencyPairModel {
  @JsonKey()
  @HiveField(0)
  final CurrencyModel baseCurrency;

  @JsonKey()
  @HiveField(1)
  final CurrencyModel targetCurrency;

  CurrencyPairModel({
    required this.baseCurrency,
    required this.targetCurrency,
  });

  factory CurrencyPairModel.fromJson(Map<String, dynamic> json) =>
      _$CurrencyPairModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyPairModelToJson(this);

  CurrencyPairModel copyWith({
    CurrencyModel? baseCurrency,
    CurrencyModel? targetCurrency,
  }) {
    return CurrencyPairModel(
      baseCurrency: baseCurrency ?? this.baseCurrency,
      targetCurrency: targetCurrency ?? this.targetCurrency,
    );
  }
}
