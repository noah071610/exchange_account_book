import 'package:currency_exchange/common/constant/data.dart';
import 'package:currency_exchange/setting/widget/setting_detail_item.dart';
import 'package:currency_exchange/setting/widget/setting_detail_layout.dart';
import 'package:currency_exchange/setting/widget/setting_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageSetting extends ConsumerStatefulWidget {
  const LanguageSetting({Key? key}) : super(key: key);

  @override
  _LanguageSettingState createState() => _LanguageSettingState();
}

class _LanguageSettingState extends ConsumerState<LanguageSetting> {
  @override
  Widget build(BuildContext context) {
    return SettingDetailLayout(
      title: context.tr('settings.language_settings'),
      child: supportLang
          .map((e) => SettingDetailItem(
                title: e['label']!,
                countryCode: e['value']!,
                settingType: SettingType.checker,
                isChecked: e['lang'] == context.locale.toString(),
                onTap: () async {
                  await context.setLocale(Locale(e['lang']!));
                  setState(() {});
                },
                noBorder: e == supportLang.last ? true : false,
              ))
          .toList(),
    );
  }
}
