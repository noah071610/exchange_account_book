import 'package:currency_exchange/common/model/account_book_btn_model.dart';
import 'package:currency_exchange/common/model/account_book_model.dart';
import 'package:currency_exchange/common/provider/account_book_list_provider.dart';
import 'package:currency_exchange/common/utils/utils.dart';
import 'package:currency_exchange/common/widgets/account_book_btn.dart';
import 'package:currency_exchange/common/widgets/account_book_tag.dart';
import 'package:currency_exchange/common/constant/category.dart';
import 'package:currency_exchange/common/model/currency_model.dart';
import 'package:currency_exchange/common/provider/category_list_provider.dart';
import 'package:currency_exchange/common/provider/currency_list_provider.dart';
import 'package:currency_exchange/common/widgets/country_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:auto_size_text/auto_size_text.dart';

var gridList = [
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
];

class CalculatorSheet extends ConsumerStatefulWidget {
  const CalculatorSheet({
    super.key,
    required this.baseData,
    required this.targetData,
    this.initialBaseAmountForShortcut,
  });

  final CurrencyModel baseData;
  final CurrencyModel targetData;
  final String? initialBaseAmountForShortcut;

  @override
  ConsumerState<CalculatorSheet> createState() => _CalculatorSheetState();
}

class _CalculatorSheetState extends ConsumerState<CalculatorSheet> {
  late String firstNumSet;
  late bool isQuickAdd = false;
  String secondNumSet = '';
  String? activeCalc;
  bool? isPageOfAccountBook = false;
  String consumptionType = 'cash';
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    firstNumSet = widget.initialBaseAmountForShortcut ?? '0';
    isQuickAdd = widget.initialBaseAmountForShortcut is String;
    isPageOfAccountBook = widget.initialBaseAmountForShortcut is String;
  }

  AccountBookBtnModel? selectedCategory;
  String accountType = 'spend';

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
    final setCurrency = ref.read(currencyListProvider.notifier).setCurrency;
    final accountBook = ref.read(accountBookListProvider.notifier);
    final currencyList = ref.watch(currencyListProvider).currencyList;
    final spendCategories =
        ref.watch(accountBookCategoryProvider).spendCategories;
    final incomeCategories =
        ref.watch(accountBookCategoryProvider).incomeCategories;

    if (selectedCategory == null) {
      setState(() {
        selectedCategory = spendCategories[0];
      });
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          width: double.infinity,
          color: Colors.white,
          constraints: BoxConstraints(
            minHeight: 0,
            maxHeight: 620,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                spacing: 3.0,
                children: [
                  CountryImage(language: widget.baseData.countryCode),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 0,
                    children: [
                      Text(
                        context.tr('countries.${widget.baseData.countryCode}'),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 1.0,
                        ),
                      ),
                      Text(
                        widget.baseData.currencyCode,
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
              GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (isPageOfAccountBook == true) return;
                  // 왼쪽 또는 오른쪽으로 스와이프 하면 발동
                  if (details.primaryVelocity != 0) {
                    onPressedCalcBtn('backspace');
                  }
                },
                onTap: () {
                  if (isPageOfAccountBook == false) return;
                  setState(() {
                    isPageOfAccountBook = false;
                  });
                },
                child: Container(
                  height: 60.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.baseData.currencySymbol,
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
              ),
              if (isPageOfAccountBook == false)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      widget.targetData.currencySymbol,
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
                      formatDouble(getExchangedAmount(
                        amount: double.parse(firstNumSet),
                        baseCode: widget.baseData.currencyCode,
                        targetCode: widget.targetData.currencyCode,
                      )),
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
                  children: gridList.map((item) {
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
              if (isPageOfAccountBook == true) ...[
                Text(
                  '분류',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    spacing: 8,
                    children: accountTypeLabels.map((k) {
                      return AccountBookTag(
                        label: k,
                        onTap: (String label) {
                          setState(() {
                            accountType = label;
                            switch (label) {
                              case 'spend':
                                selectedCategory = spendCategories[0];
                                break;
                              case 'income':
                                selectedCategory = incomeCategories[0];
                                break;
                              case 'exchange':
                                _controller.text = formatDouble(
                                    getExchangedAmount(
                                      amount: double.parse(firstNumSet),
                                      baseCode: widget.baseData.currencyCode,
                                      targetCode:
                                          widget.targetData.currencyCode,
                                    ),
                                    isDecimal: false);
                                break;
                            }
                          });
                        },
                        isActive: k == accountType,
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 3),
                if (accountType == 'spend') ...[
                  SizedBox(height: 7),
                  Text(
                    '지출 종류',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 8,
                      children: spendingCategoryLabels.map((k) {
                        return AccountBookTag(
                          label: k,
                          onTap: (String label) {
                            setState(() {
                              consumptionType = label;
                            });
                          },
                          isActive: k == consumptionType,
                        );
                      }).toList(),
                    ),
                  ),
                ],
                SizedBox(height: 10),
                if (accountType == 'exchange') ...[
                  Text(
                    '환전액 (환전 화폐)',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  CupertinoTextField(
                    controller: _controller,
                    enabled: true,
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      // disabled시 bg grey
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffix: Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Text(
                        widget.targetData.currencySymbol,
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
                if (accountType != 'exchange') ...[
                  Text(
                    '카테고리',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      spacing: 12,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(
                        accountType == 'income'
                            ? incomeCategories.length
                            : (spendCategories.length / 2).ceil(),
                        (index) {
                          if (accountType == 'income') {
                            return AccountBookBtn(
                              model: incomeCategories[index],
                              onTap: (AccountBookBtnModel model) {
                                setState(() {
                                  selectedCategory = incomeCategories[index];
                                });
                              },
                              isActive: selectedCategory == null
                                  ? false
                                  : incomeCategories[index].label ==
                                      selectedCategory!.label,
                            );
                          } else {
                            final start = index * 2;
                            final end = (index * 2 + 2) > spendCategories.length
                                ? spendCategories.length
                                : index * 2 + 2;
                            final sublist = spendCategories.sublist(start, end);
                            return Column(
                              spacing: 6,
                              children: sublist.map((k) {
                                return AccountBookBtn(
                                  model: k,
                                  onTap: (AccountBookBtnModel model) {
                                    setState(() {
                                      selectedCategory = k;
                                    });
                                  },
                                  isActive: selectedCategory == null
                                      ? false
                                      : k.label == selectedCategory!.label,
                                );
                              }).toList(),
                            );
                          }
                        },
                      ).toList(),
                    ),
                  ),
                ]
              ],
              SizedBox(height: 30),
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

                          String resultStr = result.toString();
                          resultStr = resultStr.endsWith('.0')
                              ? resultStr.substring(0, resultStr.length - 2)
                              : resultStr;
                          result = double.parse(resultStr);

                          final isBaseCard = currencyList[0].countryCode ==
                              widget.baseData.countryCode;
                          setCurrency(
                              targetIndex: isBaseCard ? 0 : 1, amount: result);
                          setCurrency(
                            targetIndex: isBaseCard ? 1 : 0,
                            amount: getExchangedAmount(
                              amount: result,
                              baseCode: widget.baseData.currencyCode,
                              targetCode: widget.targetData.currencyCode,
                            ),
                          );
                          for (var i = 2; i < 5; i++) {
                            // ignore: unnecessary_null_comparison
                            if (currencyList[i] != null) {
                              setCurrency(
                                targetIndex: i,
                                amount: getExchangedAmount(
                                  amount: result,
                                  baseCode: widget.baseData.currencyCode,
                                  targetCode: currencyList[i].currencyCode,
                                ),
                              );
                            }
                          }

                          if (isPageOfAccountBook == true) {
                            if (accountType == 'exchange' &&
                                _controller.text.isNotEmpty) {
                              accountBook.addAccountBookList(
                                AccountBookModel(
                                  accountType: accountType,
                                  subType: 'exchange',
                                  category: AccountBookBtnModel(
                                    label: 'exchangeSpend',
                                    icon: 'swap_horiz', // 환전에 어울리는 아이콘
                                    color: '#E57373', // 핑크색 (70% 밝기)
                                  ),
                                  currency: widget.baseData.copyWith(
                                    amount: result,
                                  ),
                                  isSpend: true,
                                  createdAt: DateTime.now(),
                                ),
                              );
                              accountBook.addAccountBookList(
                                AccountBookModel(
                                  accountType: accountType,
                                  subType: 'exchange',
                                  category: AccountBookBtnModel(
                                    label: 'exchangeIncome',
                                    icon: 'swap_horiz', // 환전에 어울리는 아이콘
                                    color: '#64B5F6', // 파란색 (70% 밝기)
                                  ),
                                  currency: widget.targetData.copyWith(
                                    amount: double.parse(_controller.text),
                                  ),
                                  isSpend: false,
                                  createdAt: DateTime.now(),
                                ),
                              );
                            }

                            if (selectedCategory != null &&
                                accountType != 'exchange') {
                              accountBook.addAccountBookList(
                                AccountBookModel(
                                  accountType: accountType,
                                  subType: accountType == 'income'
                                      ? 'income'
                                      : consumptionType,
                                  category: selectedCategory!,
                                  currency: widget.baseData.copyWith(
                                    amount: result,
                                  ),
                                  isSpend: accountType != 'income',
                                  createdAt: DateTime.now(),
                                ),
                              );
                            }
                          }

                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 15.0, horizontal: 30.0),
                        ),
                        child: Text(
                          isPageOfAccountBook == true ? '변환하고 저장하기' : '변환하기',
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
      ),
    );
  }
}
