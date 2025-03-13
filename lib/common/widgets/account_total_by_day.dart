import 'package:currency_exchange/common/constant/icon.dart';
import 'package:currency_exchange/common/model/currency_model.dart';
import 'package:currency_exchange/common/theme/custom_colors.dart';
import 'package:currency_exchange/common/widgets/country_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AccountTotalByDay extends StatelessWidget {
  final Map<String, dynamic> model;

  const AccountTotalByDay({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final CurrencyModel currency = model['currency'];
    final bool isTotalPositive =
        (model['incomeSum'] - model['spendSum']) >= 0.0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 3.0,
                children: [
                  CountryImage(language: currency.countryCode),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 0,
                    children: [
                      Text(
                        context.tr('countries.${currency.countryCode}'),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 1.0,
                        ),
                      ),
                      Text(
                        currency.currencyCode,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          height: 1.2,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          color: Theme.of(context)
                              .extension<CustomColors>()
                              ?.primaryBg,
                        ),
                        child: Text(
                          context.tr('총합'),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context)
                                .extension<CustomColors>()
                                ?.text,
                            height: 1.2,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        isTotalPositive ? '+' : '-',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color:
                              isTotalPositive ? Colors.green : Colors.redAccent,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        currency.currencySymbol,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color:
                              isTotalPositive ? Colors.green : Colors.redAccent,
                        ),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        (model['incomeSum'] - model['spendSum'])
                            .abs()
                            .toString(),
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color:
                              isTotalPositive ? Colors.green : Colors.redAccent,
                          height: 1.1,
                        ),
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        context.tr('수입'),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        currency.currencySymbol,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        model['incomeSum'].toString(),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                          height: 1.0,
                        ),
                      )
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        context.tr('지출'),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.redAccent,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        currency.currencySymbol,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.redAccent,
                        ),
                      ),
                      SizedBox(
                        width: 3,
                      ),
                      Text(
                        model['spendSum'].toString(),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.redAccent,
                          height: 1.0,
                        ),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
          if (false)
            Container(
              padding: EdgeInsets.only(left: 5.0, top: 12.0, bottom: 20.0),
              child: Wrap(
                spacing: 5.0,
                runSpacing: 5.0,
                alignment: WrapAlignment.start,
                children: [...model['income'], ...model['spend']]
                    .map<Widget>(
                      (e) => Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 13.0, vertical: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7.0),
                          color: Color(
                              int.parse(e[0].color.replaceFirst('#', '0xff'))),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              iconDictionary[e[0].icon],
                              size: 14,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              context.tr('category.${e[0].label}'),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                height: 1.0,
                              ),
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              '(${e[2]}건)',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                height: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
