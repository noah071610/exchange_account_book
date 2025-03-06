import 'package:currency_exchange/common/constant/category.dart';
import 'package:currency_exchange/common/model/account_book_category_model.dart';
import 'package:currency_exchange/common/model/currency_list_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:currency_exchange/common/hive/hive.dart';
import 'package:currency_exchange/common/model/currency_model.dart';
import 'package:currency_exchange/common/model/currency_pair_model.dart';

Future<AccountBookCategoryModel> loadAccountBookCategoryFromHive(
    Ref<Object?> ref) async {
  final box = await ref.read(boxProvider('category').future);
  final AccountBookCategoryModel list = box.get('category',
      defaultValue: AccountBookCategoryModel(
        categoryList: defaultCategoryList,
      ));

  return list;
}

Future<void> updateAccountBookCategoryInHive(
    Ref<Object?> ref, AccountBookCategoryModel state) async {
  final box = await ref.read(boxProvider('category').future);
  await box.put('category', state);
}
