import 'package:currency_exchange/common/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:currency_exchange/common/constant/data.dart';
import 'package:currency_exchange/common/layout/default_layout.dart';
import 'package:currency_exchange/setting/widget/list_item.dart';
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
    return DefaultLayout(
      title: context.tr('language_settings'),
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
                    children: supportLang.map((e) {
                  final isLast = e['value'] == 'KR';
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
                      title: e['label']!,
                      countryCode: e['value']!,
                      settingType: SettingType.checker,
                      isChecked: e['lang'] == context.locale.toString(),
                      onTap: () async {
                        await context.setLocale(Locale(e['lang']!));
                        setState(() {});
                      },
                    ),
                  );
                }).toList()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
