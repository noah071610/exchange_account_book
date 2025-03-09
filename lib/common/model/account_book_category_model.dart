import 'package:currency_exchange/common/model/account_book_btn_model.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account_book_category_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 5)
class AccountBookCategoryModel {
  @JsonKey()
  @HiveField(0)
  final List<AccountBookBtnModel> categoryList;

  AccountBookCategoryModel({
    required this.categoryList,
  });

  factory AccountBookCategoryModel.fromJson(Map<String, dynamic> json) =>
      _$AccountBookCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountBookCategoryModelToJson(this);

  AccountBookCategoryModel copyWith({
    List<AccountBookBtnModel>? categoryList,
  }) {
    return AccountBookCategoryModel(
      categoryList: categoryList ?? this.categoryList,
    );
  }
}
