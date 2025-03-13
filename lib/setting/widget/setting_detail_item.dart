import 'package:currency_exchange/setting/widget/setting_item.dart';
import 'package:flutter/material.dart';
import 'package:currency_exchange/common/theme/custom_colors.dart';

class SettingDetailItem extends StatelessWidget {
  final String title;
  final IconData? icon;
  final VoidCallback onTap;
  final String? countryCode;
  final String? font;
  final SettingType settingType;
  final bool? isToggled;
  final bool? isChecked;
  final bool noBorder;

  const SettingDetailItem({
    Key? key,
    required this.title,
    this.icon,
    this.countryCode,
    this.font,
    required this.onTap,
    required this.settingType,
    this.isToggled,
    this.isChecked,
    required this.noBorder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 4, top: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).extension<CustomColors>()?.containerWhiteBg,
        border: Border(
          bottom: noBorder
              ? BorderSide.none
              : BorderSide(
                  color:
                      Theme.of(context).extension<CustomColors>()!.divider100,
                  width: 1.0,
                ),
        ),
      ),
      child: SettingItem(
        title: title,
        icon: icon,
        onTap: onTap,
        countryCode: countryCode,
        font: font,
        settingType: settingType,
        isToggled: isToggled,
        isChecked: isChecked,
        noBorder: noBorder,
      ),
    );
  }
}
