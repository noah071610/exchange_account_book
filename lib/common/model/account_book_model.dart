import 'package:currency_exchange/common/model/account_book_btn_model.dart';
import 'package:currency_exchange/common/model/currency_model.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account_book_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 7)
class AccountBookModel {
  @JsonKey()
  @HiveField(0)
  final String id;

  @JsonKey()
  @HiveField(1)
  final String accountType;

  @JsonKey()
  @HiveField(2)
  final String subType;

  @JsonKey()
  @HiveField(3)
  final AccountBookBtnModel category;

  @JsonKey()
  @HiveField(4)
  final CurrencyModel currency;

  @JsonKey()
  @HiveField(5)
  final CurrencyModel targetCurrency;

  @JsonKey()
  @HiveField(6)
  final bool isSpend;

  @JsonKey()
  @HiveField(7)
  final DateTime createdAt;

  AccountBookModel({
    required this.id,
    required this.accountType,
    required this.subType,
    required this.category,
    required this.currency,
    required this.targetCurrency,
    required this.isSpend,
    required this.createdAt,
  });

  factory AccountBookModel.fromJson(Map<String, dynamic> json) =>
      _$AccountBookModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountBookModelToJson(this);

  AccountBookModel copyWith({
    String? id,
    String? accountType,
    String? subType,
    AccountBookBtnModel? category,
    CurrencyModel? currency,
    CurrencyModel? targetCurrency,
    bool? isSpend,
    DateTime? createdAt,
  }) {
    return AccountBookModel(
      id: id ?? this.id,
      accountType: accountType ?? this.accountType,
      subType: subType ?? this.subType,
      category: category ?? this.category,
      currency: currency ?? this.currency,
      targetCurrency: targetCurrency ?? this.targetCurrency,
      isSpend: isSpend ?? this.isSpend,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
