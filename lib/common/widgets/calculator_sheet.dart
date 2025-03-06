import 'package:currency_exchange/common/constant/country.dart';
import 'package:currency_exchange/common/constant/icon.dart';
import 'package:currency_exchange/common/constant/category.dart';
import 'package:currency_exchange/common/model/currency_model.dart';
import 'package:currency_exchange/common/provider/category_list_provider.dart';
import 'package:currency_exchange/common/provider/currency_provider.dart';
import 'package:currency_exchange/common/widgets/country_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CalculatorSheet extends ConsumerStatefulWidget {
  const CalculatorSheet({
    super.key,
    required this.data,
    required this.countryData,
  });

  final CurrencyModel data;
  final Map<String, String>? countryData;

  @override
  ConsumerState<CalculatorSheet> createState() => _CalculatorSheetState();
}

class _CalculatorSheetState extends ConsumerState<CalculatorSheet> {
  String firstNumSet = '0';
  String secondNumSet = '';
  String? activeCalc;
  bool? isPageOfAccountBook = false;

  void onPressedCalcBtn(String value) {
    if (value.contains(RegExp(r'^[0-9]$'))) {
      setState(() {
        if (activeCalc is String) {
          secondNumSet += value;
        } else {
          if (firstNumSet == '0') {
            firstNumSet = value;
          } else {
            firstNumSet += value;
          }
        }
      });
      return;
    }

    if (activeCalc is String &&
        secondNumSet.isNotEmpty &&
        value != 'backspace') {
      setState(() {
        switch (activeCalc) {
          case '+':
            firstNumSet =
                (double.parse(firstNumSet) + double.parse(secondNumSet))
                    .toString();
            break;
          case '-':
            firstNumSet =
                (double.parse(firstNumSet) - double.parse(secondNumSet))
                    .toString();
            break;
          case '/':
            firstNumSet =
                (double.parse(firstNumSet) / double.parse(secondNumSet))
                    .toString();
            break;
          case 'x':
            firstNumSet =
                (double.parse(firstNumSet) * double.parse(secondNumSet))
                    .toString();
            break;
          default:
            break;
        }

        firstNumSet = firstNumSet.endsWith('.0')
            ? firstNumSet.substring(0, firstNumSet.length - 2)
            : firstNumSet;
        secondNumSet = '';
      });
    }

    switch (value) {
      case 'backspace':
        setState(() {
          if (activeCalc is String) {
            if (secondNumSet.isNotEmpty) {
              secondNumSet = secondNumSet.substring(0, secondNumSet.length - 1);
            } else {
              activeCalc = null;
            }
            return;
          }
          if (firstNumSet.length <= 1) {
            firstNumSet = '0';
          } else {
            firstNumSet = firstNumSet.substring(0, firstNumSet.length - 1);
          }
        });
        break;
      case '+':
        setState(() {
          activeCalc = '+';
        });
        break;
      case '-':
        setState(() {
          activeCalc = '-';
        });
        break;
      case '*':
        setState(() {
          activeCalc = 'x';
        });
        break;
      case '/':
        setState(() {
          activeCalc = '/';
        });
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency = ref.read(currencyListProvider.notifier);
    final currencyList = ref.watch(currencyListProvider);
    final targetCountryData =
        countries[currencyList.basePair.targetCurrency.countryCode];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
      child: Container(
        width: double.infinity,
        height: 630.0,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 3.0,
              children: [
                CountryImage(language: widget.data.countryCode),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 0,
                  children: [
                    Text(
                      context.tr('countries.${widget.data.countryCode}'),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                      ),
                    ),
                    if (widget.countryData != null)
                      Text(
                        widget.countryData!['currency']!,
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
            Container(
              height: 60.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    widget.countryData!['suffix']!,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: AutoSizeText(
                      firstNumSet +
                          (activeCalc is String ? '$activeCalc' : '') +
                          secondNumSet,
                      style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.right,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  targetCountryData!['suffix']!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  firstNumSet +
                      (activeCalc is String ? '$activeCalc' : '') +
                      secondNumSet,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            if (isPageOfAccountBook == false) ...[
              GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  ...[
                    {'label': '7', 'value': '7'},
                    {'label': '8', 'value': '8'},
                    {'label': '9', 'value': '9'},
                    {'label': CupertinoIcons.divide, 'value': '/'},
                  ],
                  ...[
                    {'label': '4', 'value': '4'},
                    {'label': '5', 'value': '5'},
                    {'label': '6', 'value': '6'},
                    {'label': Icons.close, 'value': '*'},
                  ],
                  ...[
                    {'label': '1', 'value': '1'},
                    {'label': '2', 'value': '2'},
                    {'label': '3', 'value': '3'},
                    {'label': Icons.remove, 'value': '-'},
                  ],
                  ...[
                    {'label': '0', 'value': '0'},
                    {'label': '.', 'value': '.'},
                    {'label': Icons.backspace, 'value': 'backspace'},
                    {'label': Icons.add, 'value': '+'},
                  ],
                ].map((item) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {
                        onPressedCalcBtn(item['value'] as String);
                      },
                      color: Colors.white,
                      icon: item['label'] is IconData
                          ? Icon(item['label'] as IconData?,
                              color: Colors.white, size: 30)
                          : Center(
                              child: Text(
                                item['label'] as String,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ),
                  );
                }).toList(),
              ),
            ],
            if (isPageOfAccountBook == true) Container(),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color.fromARGB(255, 244, 183, 255),
                          const Color.fromARGB(255, 132, 79, 224)
                        ],
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: TextButton(
                      onPressed: () {
                        // 숫자 계산
                        double result = double.parse(firstNumSet);
                        if (activeCalc is String && secondNumSet.isNotEmpty) {
                          switch (activeCalc) {
                            case '+':
                              result += double.parse(secondNumSet);
                              break;
                            case '-':
                              result -= double.parse(secondNumSet);
                              break;
                            case '/':
                              result /= double.parse(secondNumSet);
                              break;
                            case 'x':
                              result *= double.parse(secondNumSet);
                              break;
                            default:
                              break;
                          }
                        }

                        // 결과 출력
                        print('계산 결과: $result');

                        String resultStr = result.toString();
                        resultStr = resultStr.endsWith('.0')
                            ? resultStr.substring(0, resultStr.length - 2)
                            : resultStr;
                        result = double.parse(resultStr);

                        currency.setBasePairBaseCurrency(
                            inputAmount: result, displayAmount: result);
                        currency.setBasePairTargetCurrency(
                            inputAmount: result, displayAmount: result);
                        currency.setTargetCurrencyList(
                            inputAmount: result, displayAmount: result);
                        // 시트 닫기
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 30.0),
                      ),
                      child: Text(
                        '변환하기',
                        style: TextStyle(
                          fontSize: 19,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 15),
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                      onPressed: () {
                        setState(() {
                          isPageOfAccountBook = !isPageOfAccountBook!;
                        });
                      },
                      color: Colors.white,
                      icon: Icon(
                        isPageOfAccountBook == false
                            ? Icons.receipt_outlined
                            : Icons.chevron_left,
                        color: Colors.white,
                        size: 30,
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
