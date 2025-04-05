import 'package:currency_exchange/common/constant/category.dart';
import 'package:currency_exchange/common/hive/account_book_category_hive.dart';
import 'package:currency_exchange/common/model/account_book_btn_model.dart';
import 'package:currency_exchange/common/model/account_book_category_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountBookCategoryProvider = StateNotifierProvider<
    AccountBookCategoryNotifier, AccountBookCategoryModel>((ref) {
  return AccountBookCategoryNotifier(ref);
});

class AccountBookCategoryNotifier
    extends StateNotifier<AccountBookCategoryModel> {
  final Ref _ref;

  AccountBookCategoryNotifier(this._ref)
      : super(AccountBookCategoryModel(
          spendCategories: defaultSpendCategories,
          incomeCategories: defaultIncomeCategories,
        )) {
    _initializeSetting();
  }

  Future<void> _initializeSetting() async {
    final loaded = await loadAccountBookCategoryFromHive(_ref);
    state = loaded;
  }

  void addSpendCategory(AccountBookBtnModel category) {
    final updatedSpendCategories =
        List<AccountBookBtnModel>.from(state.spendCategories)..add(category);

    state = state.copyWith(spendCategories: updatedSpendCategories);
    updateAccountBookCategoryInHive(_ref, state);
  }

  void addIncomeCategory(AccountBookBtnModel category) {
    final updatedIncomeCategories =
        List<AccountBookBtnModel>.from(state.incomeCategories)..add(category);

    state = state.copyWith(incomeCategories: updatedIncomeCategories);
    updateAccountBookCategoryInHive(_ref, state);
  }

  void removeSpendCategory(int index) {
    final updatedSpendCategories =
        List<AccountBookBtnModel>.from(state.spendCategories)..removeAt(index);

    state = state.copyWith(spendCategories: updatedSpendCategories);
    updateAccountBookCategoryInHive(_ref, state);
  }

  void reorderSpendCategories(List<AccountBookBtnModel> reorderedList) {
    state = state.copyWith(spendCategories: reorderedList);
    updateAccountBookCategoryInHive(_ref, state);
  }

  void removeIncomeCategory(int index) {
    final updatedIncomeCategories =
        List<AccountBookBtnModel>.from(state.incomeCategories)..removeAt(index);

    state = state.copyWith(incomeCategories: updatedIncomeCategories);
    updateAccountBookCategoryInHive(_ref, state);
  }

  void reorderIncomeCategories(List<AccountBookBtnModel> reorderedList) {
    state = state.copyWith(incomeCategories: reorderedList);
    updateAccountBookCategoryInHive(_ref, state);
  }

  void updateSpendCategory(int targetIndex, AccountBookBtnModel model) {
    final updatedSpendCategories =
        List<AccountBookBtnModel>.from(state.spendCategories);
    updatedSpendCategories[targetIndex] = model;

    state = state.copyWith(spendCategories: updatedSpendCategories);
    updateAccountBookCategoryInHive(_ref, state);
  }

  void updateIncomeCategory(int targetIndex, AccountBookBtnModel model) {
    final updatedIncomeCategories =
        List<AccountBookBtnModel>.from(state.incomeCategories);
    updatedIncomeCategories[targetIndex] = model;

    state = state.copyWith(incomeCategories: updatedIncomeCategories);
    updateAccountBookCategoryInHive(_ref, state);
  }
}
