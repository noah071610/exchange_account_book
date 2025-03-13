import 'package:currency_exchange/setting/widget/setting_detail_item.dart';
import 'package:currency_exchange/setting/widget/setting_detail_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:currency_exchange/common/provider/setting_provider.dart';
import 'package:currency_exchange/setting/widget/setting_item.dart';
import 'package:flutter/foundation.dart';
import 'package:easy_localization/easy_localization.dart';

class DisplaySettingTab extends ConsumerStatefulWidget {
  const DisplaySettingTab({Key? key}) : super(key: key);

  @override
  _DisplaySettingTabState createState() => _DisplaySettingTabState();
}

class _DisplaySettingTabState extends ConsumerState<DisplaySettingTab> {
  @override
  Widget build(BuildContext context) {
    final currentThemeMode = ref.watch(settingProvider).themeNum;

    return SettingDetailLayout(
      title: context.tr('display_settings'),
      child: [
        SettingDetailItem(
          title: context.tr('light'),
          icon: Icons.light_mode,
          settingType: SettingType.checker,
          isChecked: currentThemeMode == 1,
          onTap: () => _updateThemeMode(1),
          noBorder: false,
        ),
        SettingDetailItem(
          title: context.tr('dark'),
          noBorder: true,
          icon: Icons.dark_mode,
          settingType: SettingType.checker,
          isChecked: currentThemeMode == 2,
          onTap: () => _updateThemeMode(2),
        )
      ],
    );
  }

  void _updateThemeMode(int themeNum) {
    ref.read(settingProvider.notifier).setThemeMode(themeNum);
  }
}
