import 'package:currency_exchange/common/constant/dafault_data.dart';
import 'package:currency_exchange/common/hive/currency_hive.dart';
import 'package:currency_exchange/common/model/currency_card_model.dart';
import 'package:currency_exchange/common/model/currency_list_model.dart';
import 'package:currency_exchange/common/model/currency_model.dart';
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

  // void setTargetCurrencyList({
  //   String? countryCode,
  //   double? inputAmount,
  //   double? displayAmount,
  //   int? index,
  //   List<int>? quickTag,
  // }) async {
  //   final List<CurrencyModel> updatedCurrencyList =
  //       state.currencyList.map((currency) {
  //     return currency.copyWith(
  //       countryCode: countryCode,
  //       inputAmount: inputAmount,
  //       displayAmount: displayAmount,
  //       index: index,
  //       quickTag: quickTag,
  //     );
  //   }).toList();

  //   state = state.copyWith(
  //     currencyList: updatedCurrencyList,
  //   );

  //   updateCurrencyListInHive(_ref, state);
  // }

  // void toggleBasePair() async {
  //   final exchange = state.basePair.copyWith(
  //     baseCurrency: state.basePair.targetCurrency,
  //     targetCurrency: state.basePair.baseCurrency,
  //   );
  //   state = state.copyWith(
  //     basePair: exchange,
  //   );

  //   updateCurrencyListInHive(_ref, state);
  // }
}
