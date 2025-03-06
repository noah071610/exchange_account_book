import 'package:currency_exchange/common/model/currency_list_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:currency_exchange/common/hive/hive.dart';
import 'package:currency_exchange/common/model/currency_model.dart';
import 'package:currency_exchange/common/model/currency_pair_model.dart';

Future<CurrencyListModel> loadCurrencyListFromHive(Ref<Object?> ref) async {
  final box = await ref.read(boxProvider('list').future);
  final CurrencyListModel list = box.get('list',
      defaultValue: CurrencyListModel(
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
      ));

  return list;
}

Future<void> updateCurrencyListInHive(
    Ref<Object?> ref, CurrencyListModel state) async {
  final box = await ref.read(boxProvider('list').future);
  await box.put('list', state);
}
