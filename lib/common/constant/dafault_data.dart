import 'package:currency_exchange/common/model/currency_card_model.dart';
import 'package:currency_exchange/common/model/currency_list_model.dart';
import 'package:currency_exchange/common/model/setting_model.dart';

final defaultCurrencyListModel = CurrencyListModel(
  currencyList: [
    CurrencyCardModel(name: 'korea', amount: 0.0),
    CurrencyCardModel(name: 'japan', amount: 0.0),
    CurrencyCardModel(name: 'unitedstates', amount: 0.0),
    CurrencyCardModel(name: 'eurozone', amount: 0.0),
    CurrencyCardModel(name: 'china', amount: 0.0),
    CurrencyCardModel(name: 'thailand', amount: 0.0)
  ],
);

final defaultSettingModel = SettingModel(
  themeNum: 0,
  language: 'ko',
  font: 'Noto Sans',
  primaryColor: '#000000',
  subColor: '#000000',
  selectCountryForAnalytics: '',
  curCurrency: null,
);
