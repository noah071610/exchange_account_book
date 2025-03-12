import 'package:currency_exchange/common/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:currency_exchange/common/layout/default_layout.dart';
import 'package:currency_exchange/common/provider/setting_provider.dart';
import 'package:currency_exchange/setting/widget/list_item.dart';
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

    return DefaultLayout(
      title: context.tr('display_settings'),
      centerTitle: true,
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: const Color.fromARGB(8, 0, 0, 0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).extension<CustomColors>()?.containerBg,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 4, top: 4),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context)
                                .extension<CustomColors>()!
                                .divider100,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: CustomListItem(
                        title: context.tr('system'),
                        icon: Icons.settings_system_daydream,
                        settingType: SettingType.checker,
                        isChecked: currentThemeMode == 0,
                        onTap: () => _updateThemeMode(0),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 4, top: 4),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context)
                                .extension<CustomColors>()!
                                .divider100,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: CustomListItem(
                        title: context.tr('light'),
                        icon: Icons.light_mode,
                        settingType: SettingType.checker,
                        isChecked: currentThemeMode == 1,
                        onTap: () => _updateThemeMode(1),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 4, top: 4),
                      child: CustomListItem(
                        title: context.tr('dark'),
                        noBorder: true,
                        icon: Icons.dark_mode,
                        settingType: SettingType.checker,
                        isChecked: currentThemeMode == 2,
                        onTap: () => _updateThemeMode(2),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateThemeMode(int themeNum) {
    ref.read(settingProvider.notifier).setThemeMode(themeNum);
  }
}
