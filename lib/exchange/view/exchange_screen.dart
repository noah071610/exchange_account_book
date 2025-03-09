import 'package:currency_exchange/common/provider/currency_list_provider.dart';
import 'package:currency_exchange/common/widgets/currency_card.dart';
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
    print(currencyList);
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
                    CurrencyCard(
                      baseData: currencyList[0],
                      targetData: currencyList[1],
                    ),
                    Icon(
                      CupertinoIcons.repeat,
                      size: 20.0,
                    ),
                    CurrencyCard(
                      baseData: currencyList[1],
                      targetData: currencyList[0],
                    ),
                  ],
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 10,
                    children: currencyList
                        .sublist(2)
                        .map((currency) => CurrencyCard(
                              baseData: currency,
                              targetData: currencyList[0], // base currency
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
