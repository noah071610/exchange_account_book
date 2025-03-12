import 'package:currency_exchange/common/constant/currency_models.dart';
import 'package:currency_exchange/common/model/currency_list_model.dart';
import 'package:currency_exchange/common/model/setting_model.dart';

final defaultCurrencyListModel = CurrencyListModel(
  currencyList: currencyModels.sublist(0, 5),
);

final defaultSettingModel = SettingModel(
  themeNum: 0,
  language: 'ko',
  font: 'Noto Sans',
  primaryColor: '#000000',
  subColor: '#000000',
  selectCountryForAnalytics: '',
  selectedCountriesForCalender: [],
);
