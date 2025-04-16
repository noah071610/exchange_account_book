import 'package:currency_exchange/setting/widget/setting_detail_layout.dart';
import 'package:currency_exchange/setting/widget/setting_section.dart';
import 'package:flutter/material.dart';
import 'package:currency_exchange/common/constant/toast.dart';
import 'package:currency_exchange/setting/widget/setting_item.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SettingDetailLayout(child: [
      SettingSection(
        title: context.tr('settings.settings'),
        items: [
          SettingItem(
            title: context.tr('settings.currency_settings'),
            icon: Icons.font_download,
            settingType: SettingType.navigator,
            onTap: () {
              context.go('/currency-setting');
            },
          ),
          SettingItem(
            title: context.tr('settings.category_settings'),
            icon: Icons.font_download,
            settingType: SettingType.navigator,
            onTap: () {
              context.go('/category-setting');
            },
          ),
        ],
      ),
      SettingSection(
        title: context.tr('settings.settings'),
        items: [
          SettingItem(
            title: context.tr('settings.language_settings'),
            icon: Icons.language,
            settingType: SettingType.navigator,
            onTap: () {
              context.go('/language-setting');
            },
          ),
          SettingItem(
            title: context.tr('settings.display_settings'),
            icon: Icons.brightness_6,
            settingType: SettingType.navigator,
            onTap: () {
              context.go('/display-setting');
            },
          ),
        ],
      ),
      SettingSection(
        title: context.tr('settings.etc'),
        items: [
          SettingItem(
            title: context.tr('settings.feedback_and_requests'),
            icon: Icons.feedback,
            onTap: () => _launchEmail(context),
            settingType: SettingType.event,
          ),
          SettingItem(
            title: context.tr('settings.version_info'),
            icon: Icons.info,
            settingType: SettingType.event,
            onTap: () {
              showCustomToast(context: context, message: 'v1.0.0');
            },
          ),
        ],
      ),
    ]);
  }

  // Future<void> _launchAppStore() async {
  //   final Uri url = Uri.parse(
  //     'https://apps.apple.com/app/id[YOUR_APP_ID]', // iOS 앱스토어 링크
  //     // 'https://play.google.com/store/apps/details?id=[YOUR_PACKAGE_NAME]', // 안드로이드 플레이스토어 링크
  //   );
  //   if (!await launchUrl(url)) {
  //     throw Exception('앱스토어를 열 수 없습니다');
  //   }
  // }

  Future<void> _launchEmail(BuildContext context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'noah071610@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': context.tr('settings.feedback_and_requests'),
        'body': context.tr('settings.feedback_help_message')
      }),
    );

    if (!await launchUrl(emailLaunchUri)) {
      throw Exception(context.tr('settings.cannot_open_email'));
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}
