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

  void removeSpendCategory(String category) {
    final updatedSpendCategories =
        List<AccountBookBtnModel>.from(state.spendCategories)
          ..removeWhere((e) => e.label == category);

    state = state.copyWith(spendCategories: updatedSpendCategories);
    updateAccountBookCategoryInHive(_ref, state);
  }

  void reorderSpendCategories(int oldIndex, int newIndex) {
    final updatedSpendCategories =
        List<AccountBookBtnModel>.from(state.spendCategories);
    final item = updatedSpendCategories.removeAt(oldIndex);
    updatedSpendCategories.insert(newIndex, item);

    state = state.copyWith(spendCategories: updatedSpendCategories);
    updateAccountBookCategoryInHive(_ref, state);
  }

  void addIncomeCategory(AccountBookBtnModel category) {
    final updatedIncomeCategories =
        List<AccountBookBtnModel>.from(state.incomeCategories)..add(category);

    state = state.copyWith(incomeCategories: updatedIncomeCategories);
    updateAccountBookCategoryInHive(_ref, state);
  }

  void removeIncomeCategory(String category) {
    final updatedIncomeCategories =
        List<AccountBookBtnModel>.from(state.incomeCategories)
          ..removeWhere((e) => e.label == category);

    state = state.copyWith(incomeCategories: updatedIncomeCategories);
    updateAccountBookCategoryInHive(_ref, state);
  }

  void reorderIncomeCategories(int oldIndex, int newIndex) {
    final updatedIncomeCategories =
        List<AccountBookBtnModel>.from(state.incomeCategories);
    final item = updatedIncomeCategories.removeAt(oldIndex);
    updatedIncomeCategories.insert(newIndex, item);

    state = state.copyWith(incomeCategories: updatedIncomeCategories);
    updateAccountBookCategoryInHive(_ref, state);
  }
}
