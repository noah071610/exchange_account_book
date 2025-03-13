import 'package:currency_exchange/common/constant/dafault_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:currency_exchange/common/hive/hive.dart';
import 'package:currency_exchange/common/model/setting_model.dart';

Future<SettingModel> loadSettingFromHive(Ref<Object?> ref) async {
  final box = await ref.read(boxProvider('setting').future);
  final SettingModel settings = box.get(
    'setting',
    defaultValue: defaultSettingModel,
  );

  return settings;
}

Future<void> updateSettingInHive(Ref<Object?> ref, SettingModel state) async {
  final box = await ref.read(boxProvider('setting').future);
  await box.put('setting', state);
}
