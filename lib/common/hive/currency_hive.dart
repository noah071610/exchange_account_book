import 'package:currency_exchange/common/constant/dafault_data.dart';
import 'package:currency_exchange/common/model/currency_list_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:currency_exchange/common/hive/hive.dart';

Future<CurrencyListModel> loadCurrencyListFromHive(Ref<Object?> ref) async {
  final box = await ref.read(boxProvider('list').future);
  final CurrencyListModel list =
      box.get('list', defaultValue: defaultCurrencyListModel);

  return list;
}

Future<void> updateCurrencyListInHive(
    Ref<Object?> ref, CurrencyListModel state) async {
  final box = await ref.read(boxProvider('list').future);
  await box.put('list', state);
}
