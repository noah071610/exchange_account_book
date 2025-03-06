import 'package:currency_exchange/common/constant/category.dart';
import 'package:currency_exchange/common/hive/category_hive.dart';
import 'package:currency_exchange/common/hive/currency_hive.dart';
import 'package:currency_exchange/common/model/account_book_category_model.dart';
import 'package:currency_exchange/common/model/currency_list_model.dart';
import 'package:currency_exchange/common/model/currency_model.dart';
import 'package:currency_exchange/common/model/currency_pair_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountBookCategoryProvider = StateNotifierProvider<
    AccountBookCategoryNotifier, AccountBookCategoryModel>((ref) {
  return AccountBookCategoryNotifier(ref);
});

class AccountBookCategoryNotifier
    extends StateNotifier<AccountBookCategoryModel> {
  final Ref _ref;

  AccountBookCategoryNotifier(this._ref)
      : super(AccountBookCategoryModel(categoryList: defaultCategoryList)) {
    _initializeSetting();
  }

  Future<void> _initializeSetting() async {
    final loaded = await loadAccountBookCategoryFromHive(_ref);
    state = loaded;
  }
}
