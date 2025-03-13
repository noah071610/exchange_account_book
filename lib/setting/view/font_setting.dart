import 'package:currency_exchange/common/provider/setting_provider.dart';
import 'package:currency_exchange/setting/widget/setting_detail_item.dart';
import 'package:currency_exchange/setting/widget/setting_detail_layout.dart';
import 'package:currency_exchange/setting/widget/setting_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

    return SettingDetailLayout(
      title: context.tr('font_settings'),
      child: [
        'Noto Sans',
        'Lato',
        'Sunflower',
        'Nanum Gothic',
        'M PLUS 1p',
        'Noto Sans Thai',
      ]
          .map(
            (e) => SettingDetailItem(
              title: e,
              font: e,
              settingType: SettingType.checker,
              isChecked: curFont == e,
              onTap: () => ref.read(settingProvider.notifier).setFont(e),
              noBorder: e == 'Noto Sans Thai',
            ),
          )
          .toList(),
    );
  }
}
