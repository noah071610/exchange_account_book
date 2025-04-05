import 'package:currency_exchange/common/constant/currency_models.dart';
import 'package:currency_exchange/common/constant/icon.dart';
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

class AccountBookCard extends ConsumerWidget {
  final AccountBookModel model;
  final bool isActive;
  final void Function(AccountBookModel) onTap;

  const AccountBookCard({
    super.key,
    required this.model,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deleteAccountBookList =
        ref.watch(accountBookListProvider.notifier).deleteAccountBookList;
    return Slidable(
      key: ValueKey(model.createdAt),
      endActionPane: ActionPane(
        motion: DrawerMotion(),
        children: [
          SlidableAction(
            flex: 1,
            onPressed: (context) {
              final DateFormat yearFormatter = DateFormat('yyyy');
              final DateFormat monthFormatter = DateFormat('MM');
              final DateFormat dayFormatter = DateFormat('dd');

              final String year = yearFormatter.format(model.createdAt);
              final String month = monthFormatter.format(model.createdAt);
              final String day = dayFormatter.format(model.createdAt);

              deleteAccountBookList(year, month, day, model.id);
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            label: context.tr('delete'),
            // 크기 조정
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              spacing: 10.0,
              children: [
                Column(
                  children: [
                    Container(
                      width: 40.0,
                      decoration: BoxDecoration(
                        color: Color(int.parse(
                            model.category.color.replaceFirst('#', '0xff'))),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(iconDictionary[model.category.icon]),
                        onPressed: () {
                          onTap(model);
                        },
                        iconSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  spacing: 2.0,
                  children: [
                    Row(
                      spacing: 5.0,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white24
                                    : Theme.of(context)
                                        .extension<CustomColors>()
                                        ?.primaryBg,
                          ),
                          child: Text(
                            context.tr('category.${model.subType}'),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white
                                  : Theme.of(context)
                                      .extension<CustomColors>()
                                      ?.textGrey,
                              height: 1.2,
                            ),
                          ),
                        ),
                        CountryImage(
                          language:
                              currencyModels[model.currency.name]!.countryCode,
                          isSimple: true,
                          noStyle: true,
                        ),
                        Text(
                          DateFormat('HH:mm').format(model.createdAt),
                          style: TextStyle(
                            fontSize: 11,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      model.category.label.contains('category.')
                          ? context.tr(model.category.label)
                          : model.category.label,
                      style: TextStyle(fontSize: 14),
                    )
                  ],
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        model.isSpend ? '-' : '+',
                        style: TextStyle(
                          fontSize: 18,
                          height: 1.0,
                          fontWeight: FontWeight.bold,
                          color:
                              model.isSpend ? Colors.redAccent : Colors.green,
                        ),
                      ),
                      SizedBox(
                        width: 2,
                      ),
                      Text(
                        currencyModels[model.currency.name]!.currencySymbol,
                        style: TextStyle(
                          fontSize: 18,
                          height: 1.0,
                          fontWeight: FontWeight.bold,
                          color:
                              model.isSpend ? Colors.redAccent : Colors.green,
                        ),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        formatDouble(model.currency.amount),
                        style: TextStyle(
                          fontSize: 18,
                          height: 1.0,
                          fontWeight: FontWeight.bold,
                          color:
                              model.isSpend ? Colors.redAccent : Colors.green,
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      model.isSpend ? '-' : '+',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context)
                            .extension<CustomColors>()
                            ?.textGrey,
                      ),
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Text(
                      currencyModels[model.targetCurrency.name]!.currencySymbol,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context)
                            .extension<CustomColors>()
                            ?.textGrey,
                      ),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Text(
                      formatDouble(model.targetCurrency.amount),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context)
                            .extension<CustomColors>()
                            ?.textGrey,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
