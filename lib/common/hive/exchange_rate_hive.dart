import 'package:currency_exchange/common/constant/temp.dart';
import 'package:currency_exchange/common/model/exchange_rate_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:currency_exchange/common/hive/hive.dart';

final key = 'exchange_rate';

Future<ExchangeRateModel> loadExchangeRateInHive(Ref<Object?> ref) async {
  final box = await ref.read(boxProvider(key).future);
  final ExchangeRateModel list =
      box.get(key, defaultValue: ExchangeRateModel(map: defaultExchange));

  return list;
}

Future<void> updateExchangeRateInHive(
    Ref<Object?> ref, ExchangeRateModel state) async {
  final box = await ref.read(boxProvider(key).future);
  await box.put(key, state);
}
