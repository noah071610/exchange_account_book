import 'package:currency_exchange/common/constant/country.dart';
import 'package:currency_exchange/common/constant/icon.dart';
import 'package:currency_exchange/common/constant/category.dart';
import 'package:currency_exchange/common/model/currency_model.dart';
import 'package:currency_exchange/common/provider/category_list_provider.dart';
import 'package:currency_exchange/common/provider/currency_provider.dart';
import 'package:currency_exchange/common/widgets/calculator_sheet.dart';
import 'package:currency_exchange/common/widgets/country_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";

class CalculatorScreen extends ConsumerWidget {
  const CalculatorScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final currencyList = ref.watch(currencyListProvider);
    final currencyListNotifier = ref.read(currencyListProvider.notifier);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: Column(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              spacing: 20.0,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  spacing: 3,
                  children: [
                    CurrencyCard(data: currencyList.basePair.baseCurrency),
                    GestureDetector(
                      onTap: () {
                        currencyListNotifier.toggleBasePair();
                      },
                      child: Icon(
                        CupertinoIcons.repeat,
                        size: 20.0,
                      ),
                    ),
                    CurrencyCard(data: currencyList.basePair.targetCurrency),
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 10,
                    children: currencyList.currencyList
                        .map((currency) => CurrencyCard(
                              data: currency,
                              isSimple: true,
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Divider(
              height: 15,
              thickness: 0,
              indent: 0,
              endIndent: 0,
              color: Colors.black38,
            ),
            SizedBox(
              height: 15,
            ),
            BottomWidget(),
          ],
        ),
      ),
    );
  }
}

class BottomWidget extends ConsumerStatefulWidget {
  const BottomWidget({
    super.key,
  });

  @override
  ConsumerState<BottomWidget> createState() => _BottomWidgetState();
}

class _BottomWidgetState extends ConsumerState<BottomWidget> {
  bool isFirstButtonSelected = true;

  void selectButton(int buttonIndex) {
    setState(() {
      isFirstButtonSelected = (buttonIndex == 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.red,
          height: 200.0,
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}

class AccountBookTypeBtn extends StatelessWidget {
  final String color;
  final String icon;
  final String label;
  const AccountBookTypeBtn({
    super.key,
    required this.color,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(int.parse(color.replaceFirst('#', '0xff'))),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(iconDictionary[icon]),
            onPressed: () {},
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 3,
        ),
        Text(label, style: TextStyle(fontSize: 11)),
      ],
    );
  }
}

class CurrencyCard extends ConsumerWidget {
  final CurrencyModel data;
  final bool isSimple;

  const CurrencyCard({
    super.key,
    this.isSimple = false,
    required this.data,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countryData = countries[data.countryCode];
    if (countryData == null) return Container();

    return GestureDetector(
      onTap: isSimple
          ? () {}
          : () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return CalculatorSheet(data: data, countryData: countryData);
                },
              );
            },
      child: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: isSimple
              ? MainAxisAlignment.start
              : MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              spacing: 3.0,
              children: [
                CountryImage(language: data.countryCode, isSimple: isSimple),
                if (!isSimple)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 0,
                    children: [
                      Text(
                        context.tr('countries.${data.countryCode}'),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 1.0,
                        ),
                      ),
                      Text(
                        countryData['currency']!,
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
            if (isSimple)
              SizedBox(
                width: 7,
              ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:
                  isSimple ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: isSimple ? 8 : 12.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(isSimple ? 4.0 : 8.0),
                    color: const Color.fromARGB(255, 191, 245, 190),
                  ),
                  child: Text(
                    '${countryData['suffix']!} ${data.displayAmount}',
                    style: TextStyle(
                      fontSize: isSimple ? 12 : 14,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 24, 118, 28),
                      height: 1.2,
                    ),
                  ),
                  // textAlign: TextAlign.right,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 2.5),
                  child: Text(
                    '25만6천700원',
                    style: TextStyle(
                      fontSize: isSimple ? 11 : 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
