import 'package:currency_exchange/common/provider/currency_list_provider.dart';
import 'package:currency_exchange/common/theme/custom_colors.dart';
import 'package:currency_exchange/common/widgets/currency_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExchangeScreen extends ConsumerWidget {
  const ExchangeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final currencyList = ref.watch(currencyListProvider).currencyList;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              spacing: 15.0,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
                  spacing: 8,
                  children: [
                    Container(
                      height: 20.0,
                      padding: EdgeInsets.symmetric(horizontal: 3.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        context.tr('main_country'),
                        style: TextStyle(
                          color: Theme.of(context)
                              .extension<CustomColors>()
                              ?.textGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    CurrencyCard(
                      cardBaseData: currencyList[0],
                      cardTargetData: currencyList[1],
                      isBase: true,
                    ),
                    CurrencyCard(
                      cardBaseData: currencyList[1],
                      cardTargetData: currencyList[0],
                    ),
                    Container(
                      height: 20.0,
                      padding: EdgeInsets.symmetric(horizontal: 3.0),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        context.tr('another_country'),
                        style: TextStyle(
                          color: Theme.of(context)
                              .extension<CustomColors>()
                              ?.textGrey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    ...currencyList.sublist(2).map((currency) => CurrencyCard(
                          cardBaseData: currency,
                          cardTargetData: currencyList[0],
                        ))
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            // Divider(
            //   height: 15,
            //   thickness: 0,
            //   indent: 0,
            //   endIndent: 0,
            //   color: Colors.black38,
            // ),
            // SizedBox(
            //   height: 15,
            // ),
            // BottomWidget(),
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
