import 'package:currency_exchange/common/constant/icon.dart';
import 'package:currency_exchange/common/model/account_book_btn_model.dart';
import 'package:currency_exchange/common/theme/custom_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AccountBookBtn extends StatelessWidget {
  final AccountBookBtnModel model;
  final bool isActive;
  final void Function(AccountBookBtnModel) onTap;

  const AccountBookBtn({
    super.key,
    required this.model,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Opacity(
          opacity: isActive ? 1.0 : 0.3,
          child: Container(
            decoration: BoxDecoration(
              color: Color(int.parse(model.color.replaceFirst('#', '0xff'))),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(iconDictionary[model.icon]),
              onPressed: () {
                onTap(model);
              },
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 3,
        ),
        Text(
          model.label.contains('category.')
              ? context.tr(model.label)
              : model.label,
          style: TextStyle(
            fontSize: 12,
            color: isActive
                ? null
                : Theme.of(context).extension<CustomColors>()?.textGrey,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }
}
