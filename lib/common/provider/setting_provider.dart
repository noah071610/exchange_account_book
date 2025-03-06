import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:currency_exchange/common/hive/setting_hive.dart';
import 'package:currency_exchange/common/model/setting_model.dart';

final settingProvider =
    StateNotifierProvider<SettingNotifier, SettingModel>((ref) {
  return SettingNotifier(ref);
});

class SettingNotifier extends StateNotifier<SettingModel> {
  final Ref _ref;

  SettingNotifier(this._ref)
      : super(SettingModel(
          font: 'Noto Sans',
          language: 'ko',
          themeNum: 0,
          primaryColor: '#000000',
          subColor: '#000000',
        )) {
    _initializeSetting();
  }

  Future<void> _initializeSetting() async {
    final loaded = await loadSettingFromHive(_ref);
    state = loaded;
  }

  void setFont(String font) async {
    state = state.copyWith(font: font);
    await updateSettingInHive(_ref, state);
  }

  void setThemeMode(int themeNum) async {
    state = state.copyWith(themeNum: themeNum);
    await updateSettingInHive(_ref, state);
  }
}
