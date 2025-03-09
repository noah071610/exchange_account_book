import 'package:currency_exchange/common/model/account_book_model.dart';

import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account_book_list_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 8)
class AccountBookListModel {
  @JsonKey()
  @HiveField(0)
  final Map<String, Map<String, Map<String, List<AccountBookModel>>>>
      accountBookDic;

  AccountBookListModel({
    required this.accountBookDic,
  });

  factory AccountBookListModel.fromJson(Map<String, dynamic> json) =>
      _$AccountBookListModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountBookListModelToJson(this);

  AccountBookListModel copyWith({
    Map<String, Map<String, Map<String, List<AccountBookModel>>>>?
        accountBookDic,
  }) {
    return AccountBookListModel(
      accountBookDic: accountBookDic ?? this.accountBookDic,
    );
  }
}
