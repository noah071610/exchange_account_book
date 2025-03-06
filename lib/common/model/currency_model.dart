import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'currency_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 3)
class CurrencyModel {
  @JsonKey()
  @HiveField(0)
  final String countryCode;

  @JsonKey()
  @HiveField(1)
  final double inputAmount;

  @JsonKey()
  @HiveField(2)
  final double displayAmount;

  @JsonKey()
  @HiveField(3)
  final int index;

  @JsonKey()
  @HiveField(4)
  final List<int> quickTag;

  CurrencyModel({
    required this.countryCode,
    required this.inputAmount,
    required this.displayAmount,
    required this.index,
    required this.quickTag,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) =>
      _$CurrencyModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyModelToJson(this);

  CurrencyModel copyWith({
    String? countryCode,
    double? inputAmount,
    double? displayAmount,
    int? index,
    List<int>? quickTag,
  }) {
    return CurrencyModel(
      countryCode: countryCode ?? this.countryCode,
      inputAmount: inputAmount ?? this.inputAmount,
      displayAmount: displayAmount ?? this.displayAmount,
      index: index ?? this.index,
      quickTag: quickTag ?? this.quickTag,
    );
  }
}
