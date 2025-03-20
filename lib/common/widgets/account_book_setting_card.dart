import 'package:currency_exchange/common/constant/currency_models.dart';
import 'package:currency_exchange/common/constant/icon.dart';
import 'package:currency_exchange/common/model/account_book_btn_model.dart';
import 'package:currency_exchange/common/model/account_book_model.dart';
import 'package:currency_exchange/common/provider/account_book_list_provider.dart';
import 'package:currency_exchange/common/theme/custom_colors.dart';
import 'package:currency_exchange/common/utils/utils.dart';
import 'package:currency_exchange/common/widgets/country_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

class AccountBookSettingCard extends ConsumerWidget {
  final AccountBookBtnModel model;
  final String type;
  final int index;

  const AccountBookSettingCard({
    super.key,
    required this.model,
    required this.type,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Color(int.parse(model.color.replaceFirst('#', '0xff'))),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(iconDictionary[model.icon]),
            onPressed: () {
              context.go('/category-setting/$type/$index');
            },
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 3,
        ),
        Text(
          context.tr('category.${model.label}'),
          style: TextStyle(
            fontSize: 12,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }
}
