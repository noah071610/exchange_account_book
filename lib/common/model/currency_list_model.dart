import 'package:currency_exchange/common/model/currency_model.dart';
import 'package:currency_exchange/common/model/currency_pair_model.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'currency_list_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class CurrencyListModel {
  @JsonKey()
  @HiveField(0)
  final CurrencyPairModel basePair;

  @JsonKey()
  @HiveField(1)
  final List<CurrencyModel> currencyList;

  CurrencyListModel({
    required this.basePair,
    required this.currencyList,
  });

  factory CurrencyListModel.fromJson(Map<String, dynamic> json) =>
      _$CurrencyListModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyListModelToJson(this);

  CurrencyListModel copyWith({
    CurrencyPairModel? basePair,
    List<CurrencyModel>? currencyList,
  }) {
    return CurrencyListModel(
      basePair: basePair ?? this.basePair,
      currencyList: currencyList ?? this.currencyList,
    );
  }
}
