import 'package:currency_exchange/common/constant/currency_models.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:currency_exchange/common/constant/color.dart';
import 'package:currency_exchange/common/theme/custom_colors.dart';
import 'package:currency_exchange/common/widgets/country_image.dart';

enum SettingType {
  toggle,
  navigator,
  checker,
  event,
}

class SettingItem extends StatelessWidget {
  final String title;
  final IconData? icon;
  final VoidCallback onTap;
  final String? countryCode;
  final String? font;
  final SettingType settingType;
  final bool? isToggled;
  final bool? isChecked;
  final bool? noBorder;

  const SettingItem({
    Key? key,
    required this.title,
    this.icon,
    this.countryCode,
    this.font,
    required this.onTap,
    required this.settingType,
    this.isToggled,
    this.isChecked,
    this.noBorder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextStyle? defaultTextStyle = Theme.of(context).textTheme.bodyMedium;

    return ListTile(
      leading: countryCode != null
          ? CountryImage(
              language: countryCode!,
            )
          : null,
      title: Text(
        title,
        style: font != null ? GoogleFonts.getFont(font!) : defaultTextStyle,
      ),
      trailing: _buildTrailing(context),
      onTap: settingType == SettingType.checker && isChecked == true
          ? null
          : onTap,
    );
  }

  Widget? _buildTrailing(BuildContext context) {
    switch (settingType) {
      case SettingType.toggle:
        return Switch(
          value: isToggled ?? false,
          onChanged: (value) => onTap(),
        );
      case SettingType.navigator:
        return Icon(Icons.chevron_right, color: BODY_TEXT_COLOR);
      case SettingType.checker:
        return isChecked == true
            ? Icon(Icons.check,
                color: Theme.of(context).extension<CustomColors>()!.primary)
            : null;
      case SettingType.event:
        return null;
    }
  }
}
