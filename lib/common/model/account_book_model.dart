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
  final String accountType;

  @JsonKey()
  @HiveField(1)
  final String subType;

  @JsonKey()
  @HiveField(2)
  final AccountBookBtnModel category;

  @JsonKey()
  @HiveField(3)
  final CurrencyModel currency;

  @JsonKey()
  @HiveField(4)
  final bool isSpend;

  @JsonKey()
  @HiveField(5)
  final DateTime createdAt;

  AccountBookModel({
    required this.accountType,
    required this.subType,
    required this.isSpend,
    required this.category,
    required this.currency,
    required this.createdAt,
  });

  factory AccountBookModel.fromJson(Map<String, dynamic> json) =>
      _$AccountBookModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountBookModelToJson(this);

  AccountBookModel copyWith({
    String? accountType,
    String? subType,
    AccountBookBtnModel? category,
    CurrencyModel? currency,
    bool? isSpend,
    DateTime? createdAt,
  }) {
    return AccountBookModel(
      accountType: accountType ?? this.accountType,
      subType: subType ?? this.subType,
      isSpend: isSpend ?? this.isSpend,
      category: category ?? this.category,
      currency: currency ?? this.currency,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
