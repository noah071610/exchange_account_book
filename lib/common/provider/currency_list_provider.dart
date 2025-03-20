import 'package:currency_exchange/common/constant/dafault_data.dart';
import 'package:currency_exchange/common/constant/toast.dart';
import 'package:currency_exchange/common/hive/currency_hive.dart';
import 'package:currency_exchange/common/model/currency_card_model.dart';
import 'package:currency_exchange/common/model/currency_list_model.dart';
import 'package:currency_exchange/common/model/currency_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currencyListProvider =
    StateNotifierProvider<CurrencyListNotifier, CurrencyListModel>((ref) {
  return CurrencyListNotifier(ref);
});

class CurrencyListNotifier extends StateNotifier<CurrencyListModel> {
  final Ref _ref;

  CurrencyListNotifier(this._ref) : super(defaultCurrencyListModel) {
    _initializeSetting();
  }

  Future<void> _initializeSetting() async {
    final loaded = await loadCurrencyListFromHive(_ref);
    state = loaded;
  }

  void setCurrency({
    required int targetIndex,
    double? amount,
  }) async {
    final updatedCurrency = state.currencyList[targetIndex].copyWith(
      amount: amount,
    );

    final updatedCurrencyList =
        List<CurrencyCardModel>.from(state.currencyList);
    updatedCurrencyList[targetIndex] = updatedCurrency;

    state = state.copyWith(currencyList: updatedCurrencyList);

    await updateCurrencyListInHive(_ref, state);
  }

  void addCurrency(CurrencyCardModel newCurrency, BuildContext context) {
    final updatedCurrencyList = List<CurrencyCardModel>.from(state.currencyList)
      ..add(newCurrency);

    state = state.copyWith(currencyList: updatedCurrencyList);
    updateCurrencyListInHive(_ref, state);
  }

  void removeCurrency(String name, BuildContext context) {
    final updatedCurrencyList = List<CurrencyCardModel>.from(state.currencyList)
      ..removeWhere((e) => e.name == name);

    state = state.copyWith(currencyList: updatedCurrencyList);
    updateCurrencyListInHive(_ref, state);
  }

  void reorderCurrencyList(int oldIndex, int newIndex) {
    final updatedCurrencyList =
        List<CurrencyCardModel>.from(state.currencyList);
    final item = updatedCurrencyList.removeAt(oldIndex);
    updatedCurrencyList.insert(newIndex, item);

    state = state.copyWith(currencyList: updatedCurrencyList);
    updateCurrencyListInHive(_ref, state);
  }
}
