import 'package:currency_exchange/setting/widget/setting_item.dart';
import 'package:flutter/material.dart';
import 'package:currency_exchange/common/theme/custom_colors.dart';

class SettingSection extends StatelessWidget {
  final String title;
  final List<SettingItem> items;

  const SettingSection({
    Key? key,
    required this.title,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 7, left: 2),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color:
                Theme.of(context).extension<CustomColors>()?.containerWhiteBg,
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => Divider(
              height: 1,
              color: Theme.of(context).extension<CustomColors>()!.divider100,
            ),
            itemBuilder: (context, index) => items[index],
          ),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
