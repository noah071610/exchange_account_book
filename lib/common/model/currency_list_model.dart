import 'package:currency_exchange/common/model/currency_model.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'currency_list_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class CurrencyListModel {
  @JsonKey()
  @HiveField(0)
  final List<CurrencyModel> currencyList;

  CurrencyListModel({
    required this.currencyList,
  });

  factory CurrencyListModel.fromJson(Map<String, dynamic> json) =>
      _$CurrencyListModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyListModelToJson(this);

  CurrencyListModel copyWith({
    List<CurrencyModel>? currencyList,
  }) {
    return CurrencyListModel(
      currencyList: currencyList ?? this.currencyList,
    );
  }
}
