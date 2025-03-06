import 'package:currency_exchange/common/hive/currency_hive.dart';
import 'package:currency_exchange/common/model/currency_list_model.dart';
import 'package:currency_exchange/common/model/currency_model.dart';
import 'package:currency_exchange/common/model/currency_pair_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currencyListProvider =
    StateNotifierProvider<CurrencyListNotifier, CurrencyListModel>((ref) {
  return CurrencyListNotifier(ref);
});

class CurrencyListNotifier extends StateNotifier<CurrencyListModel> {
  final Ref _ref;

  CurrencyListNotifier(this._ref)
      : super(CurrencyListModel(
          basePair: CurrencyPairModel(
            baseCurrency: CurrencyModel(
              countryCode: 'kr',
              inputAmount: 0,
              displayAmount: 0,
              index: 0,
              quickTag: [],
            ),
            targetCurrency: CurrencyModel(
              countryCode: 'jp',
              inputAmount: 0,
              displayAmount: 0,
              index: 1,
              quickTag: [],
            ),
          ),
          currencyList: [
            CurrencyModel(
              countryCode: 'us',
              inputAmount: 0,
              displayAmount: 0,
              index: 0,
              quickTag: [],
            ),
            CurrencyModel(
              countryCode: 'eu',
              inputAmount: 0,
              displayAmount: 0,
              index: 1,
              quickTag: [],
            ),
            CurrencyModel(
              countryCode: 'cn',
              inputAmount: 0,
              displayAmount: 0,
              index: 2,
              quickTag: [],
            ),
            CurrencyModel(
              countryCode: 'au',
              inputAmount: 0,
              displayAmount: 0,
              index: 3,
              quickTag: [],
            ),
          ],
        )) {
    _initializeSetting();
  }

  Future<void> _initializeSetting() async {
    final loaded = await loadCurrencyListFromHive(_ref);
    state = loaded;
  }

  void setBasePairBaseCurrency({
    String? countryCode,
    double? inputAmount,
    double? displayAmount,
    int? index,
    List<int>? quickTag,
  }) async {
    state = state.copyWith(
        basePair: state.basePair.copyWith(
      baseCurrency: state.basePair.baseCurrency.copyWith(
        countryCode: countryCode,
        inputAmount: inputAmount,
        displayAmount: displayAmount,
        index: index,
        quickTag: quickTag,
      ),
    ));
  }

  void setBasePairTargetCurrency({
    String? countryCode,
    double? inputAmount,
    double? displayAmount,
    int? index,
    List<int>? quickTag,
  }) async {
    state = state.copyWith(
        basePair: state.basePair.copyWith(
      targetCurrency: state.basePair.targetCurrency.copyWith(
        countryCode: countryCode,
        inputAmount: inputAmount,
        displayAmount: displayAmount,
        index: index,
        quickTag: quickTag,
      ),
    ));
  }

  void setTargetCurrencyList({
    String? countryCode,
    double? inputAmount,
    double? displayAmount,
    int? index,
    List<int>? quickTag,
  }) async {
    final List<CurrencyModel> updatedCurrencyList =
        state.currencyList.map((currency) {
      return currency.copyWith(
        countryCode: countryCode,
        inputAmount: inputAmount,
        displayAmount: displayAmount,
        index: index,
        quickTag: quickTag,
      );
    }).toList();

    state = state.copyWith(
      currencyList: updatedCurrencyList,
    );
  }

  void toggleBasePair() async {
    final exchange = state.basePair.copyWith(
      baseCurrency: state.basePair.targetCurrency,
      targetCurrency: state.basePair.baseCurrency,
    );
    state = state.copyWith(
      basePair: exchange,
    );
  }
}
