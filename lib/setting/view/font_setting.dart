import 'package:currency_exchange/common/provider/setting_provider.dart';
import 'package:currency_exchange/common/theme/custom_colors.dart';
import 'package:currency_exchange/setting/widget/list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:currency_exchange/common/layout/default_layout.dart';
import 'package:flutter/foundation.dart';
import 'package:easy_localization/easy_localization.dart';

class FontSetting extends ConsumerStatefulWidget {
  const FontSetting({Key? key}) : super(key: key);

  @override
  ConsumerState createState() => _FontSettingState();
}

class _FontSettingState extends ConsumerState<FontSetting> {
  @override
  Widget build(BuildContext context) {
    final curFont = ref.watch(settingProvider).font;

    return DefaultLayout(
      title: context.tr('font_settings'),
      bottomSafe: false,
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
                    'Noto Sans',
                    'Lato',
                    'Sunflower',
                    'Nanum Gothic',
                    'M PLUS 1p',
                    'Noto Sans Thai',
                  ].asMap().entries.map(
                    (entry) {
                      final isLast = entry.key == 5;
                      final e = entry.value;
                      return Container(
                        padding: const EdgeInsets.only(bottom: 4, top: 4),
                        decoration: BoxDecoration(
                          border: isLast
                              ? null
                              : Border(
                                  bottom: BorderSide(
                                    color: Theme.of(context)
                                        .extension<CustomColors>()!
                                        .divider100,
                                    width: 1.0,
                                  ),
                                ),
                        ),
                        child: CustomListItem(
                            title: e,
                            font: e,
                            settingType: SettingType.checker,
                            isChecked: curFont == e,
                            onTap: () =>
                                ref.read(settingProvider.notifier).setFont(e)),
                      );
                    },
                  ).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
