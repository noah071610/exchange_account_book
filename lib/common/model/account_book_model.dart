import 'package:currency_exchange/common/model/account_book_btn_model.dart';
import 'package:currency_exchange/common/model/account_book_category_model.dart';
import 'package:currency_exchange/common/model/currency_model.dart';

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account_book_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 7)
class AccountBookModel {
  @JsonKey()
  @HiveField(0)
  final AccountBookBtnModel category;

  @JsonKey()
  @HiveField(1)
  final String consumptionType;

  @JsonKey()
  @HiveField(2)
  final bool isSpend;

  @JsonKey()
  @HiveField(3)
  final CurrencyModel baseCurrency;

  @JsonKey()
  @HiveField(5)
  final CurrencyModel targetCurrency;

  AccountBookModel({
    required this.category,
    required this.consumptionType,
    required this.isSpend,
    required this.baseCurrency,
    required this.targetCurrency,
  });

  factory AccountBookModel.fromJson(Map<String, dynamic> json) =>
      _$AccountBookModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountBookModelToJson(this);

  AccountBookModel copyWith({
    AccountBookBtnModel? category,
    String? consumptionType,
    bool? isSpend,
    CurrencyModel? baseCurrency,
    CurrencyModel? targetCurrency,
  }) {
    return AccountBookModel(
      category: category ?? this.category,
      consumptionType: consumptionType ?? this.consumptionType,
      isSpend: isSpend ?? this.isSpend,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      targetCurrency: targetCurrency ?? this.targetCurrency,
    );
  }
}
