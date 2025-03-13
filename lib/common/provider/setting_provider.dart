import 'package:currency_exchange/common/constant/dafault_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:currency_exchange/common/hive/setting_hive.dart';
import 'package:currency_exchange/common/model/setting_model.dart';

final settingProvider =
    StateNotifierProvider<SettingNotifier, SettingModel>((ref) {
  return SettingNotifier(ref);
});

class SettingNotifier extends StateNotifier<SettingModel> {
  final Ref _ref;

  SettingNotifier(this._ref) : super(defaultSettingModel) {
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

  void setSelectedCountriesForCalendar(String target) async {
    final list = List<String>.from(state.selectedCountriesForCalender);

    if (list.contains(target)) {
      print(list);
      if (list.length == 1) {
        return;
      }
      list.remove(target);
    } else {
      list.add(target);
    }
    state = state.copyWith(selectedCountriesForCalender: list);
    await updateSettingInHive(_ref, state);
  }

  void setSelectedCountryForAnalytics(String target) async {
    state = state.copyWith(selectCountryForAnalytics: target);
    await updateSettingInHive(_ref, state);
  }
}
