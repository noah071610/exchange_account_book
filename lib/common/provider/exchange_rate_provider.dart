import 'package:currency_exchange/common/constant/temp.dart';
import 'package:currency_exchange/common/hive/exchange_rate_hive.dart';
import 'package:currency_exchange/common/model/exchange_rate_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final exchangeRateProvider =
    StateNotifierProvider<ExchangeRateNotifier, ExchangeRateModel>((ref) {
  return ExchangeRateNotifier(ref);
});

class ExchangeRateNotifier extends StateNotifier<ExchangeRateModel> {
  final Ref _ref;

  ExchangeRateNotifier(this._ref)
      : super(ExchangeRateModel(map: defaultExchange)) {
    _initializeSetting();
  }

  Future<void> _initializeSetting() async {
    final loaded = await loadExchangeRateInHive(_ref);
    state = loaded;
  }

  Future<void> updateExchangeRate(ExchangeRateModel model) async {
    state = model;
    await updateExchangeRateInHive(_ref, state);
  }
}
