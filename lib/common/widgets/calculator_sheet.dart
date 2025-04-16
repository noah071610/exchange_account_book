import 'package:currency_exchange/common/constant/currency_models.dart';
import 'package:currency_exchange/common/model/account_book_btn_model.dart';
import 'package:currency_exchange/common/model/account_book_model.dart';
import 'package:currency_exchange/common/model/currency_card_model.dart';
import 'package:currency_exchange/common/provider/account_book_list_provider.dart';
import 'package:currency_exchange/common/provider/setting_provider.dart';
import 'package:currency_exchange/common/theme/custom_colors.dart';
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
import 'package:logger/logger.dart';

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

final logger = Logger();

class CalculatorSheet extends ConsumerStatefulWidget {
  const CalculatorSheet({
    super.key,
    required this.baseData,
    required this.targetData,
    this.initialBaseAmountForShortcut,
    this.isForAccountBook = false,
    this.isForAccountOnly = false,
    this.selectedCountry,
  });

  final CurrencyModel baseData;
  final CurrencyModel targetData;
  final String? initialBaseAmountForShortcut;
  final bool? isForAccountOnly;
  final String? selectedCountry;
  final bool isForAccountBook;

  @override
  ConsumerState<CalculatorSheet> createState() => _CalculatorSheetState();
}

class _CalculatorSheetState extends ConsumerState<CalculatorSheet> {
  late String firstNumSet;
  late bool isQuickAdd = false;
  String secondNumSet = '';
  String? activeCalc;
  bool isPageOfAccountBook = false;
  String consumptionType = 'cash';
  String? selectedCountry;
  late CurrencyModel _currentBaseData;
  late CurrencyModel _currentTargetData;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    firstNumSet = widget.initialBaseAmountForShortcut ?? '0';
    isQuickAdd = widget.initialBaseAmountForShortcut is String;
    isPageOfAccountBook = widget.isForAccountOnly == true
        ? false
        : widget.initialBaseAmountForShortcut is String;
    selectedCountry = widget.selectedCountry;
    _currentBaseData = widget.baseData;
    _currentTargetData = widget.targetData;
  }

  AccountBookBtnModel? selectedCategory;
  String accountType = 'spend';

  void onPressedCalcBtn(String value) {
    if (value.contains(RegExp(r'^[0-9\.]$'))) {
      setState(() {
        if (activeCalc is String) {
          if ((secondNumSet == '0' || secondNumSet.isEmpty) && value == '.' ||
              (value == '.' && secondNumSet.contains('.'))) {
            return;
          }
          if (value == '.' && secondNumSet.contains('.')) return;
          secondNumSet += value;
        } else {
          if ((firstNumSet == '0' || firstNumSet.isEmpty) && value == '.' ||
              (value == '.' && firstNumSet.contains('.'))) {
            return;
          }
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
                    .toStringAsFixed(2);
            break;
          case '-':
            firstNumSet =
                (double.parse(firstNumSet) - double.parse(secondNumSet))
                    .toStringAsFixed(2);
            break;
          case '/':
            firstNumSet =
                (double.parse(firstNumSet) / double.parse(secondNumSet))
                    .toStringAsFixed(2);
            break;
          case 'x':
            firstNumSet =
                (double.parse(firstNumSet) * double.parse(secondNumSet))
                    .toStringAsFixed(2);
            break;
          default:
            break;
        }

        firstNumSet = firstNumSet.endsWith('.0')
            ? firstNumSet.substring(0, firstNumSet.length - 2)
            : firstNumSet;
        secondNumSet = '';
        if (value == 'equal') {
          activeCalc = null;
        }
      });
    }

    switch (value) {
      case 'backspace':
        setState(() {
          if (activeCalc is String) {
            if (secondNumSet.isNotEmpty) {
              secondNumSet = secondNumSet.substring(0, secondNumSet.length - 1);
              if (secondNumSet.length == 1 && secondNumSet[0] == '-') {
                secondNumSet = '';
              }
            } else {
              activeCalc = null;
            }
            return;
          }
          if (firstNumSet.length <= 1) {
            firstNumSet = '0';
          } else {
            firstNumSet = firstNumSet.substring(0, firstNumSet.length - 1);
            if (firstNumSet.length == 1 && firstNumSet[0] == '-') {
              firstNumSet = '0';
            }
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
      case '.':
        setState(() {
          activeCalc = '+';
        });
        break;
      default:
    }
  }

  double calculateLeft() {
// 숫자 계산
    double result = double.parse(firstNumSet);
    if (activeCalc is String && secondNumSet.isNotEmpty) {
      switch (activeCalc) {
        case '+':
          result += double.parse(secondNumSet);
          result = double.parse(result.toStringAsFixed(2));
          break;
        case '-':
          result -= double.parse(secondNumSet);
          result = double.parse(result.toStringAsFixed(2));
          break;
        case '/':
          result /= double.parse(secondNumSet);
          result = double.parse(result.toStringAsFixed(2));
          break;
        case 'x':
          result *= double.parse(secondNumSet);
          result = double.parse(result.toStringAsFixed(2));
          break;
        default:
          break;
      }
    }

    String resultStr = result.toString();
    resultStr = resultStr.endsWith('.0')
        ? resultStr.substring(0, resultStr.length - 2)
        : resultStr;
    firstNumSet = resultStr;
    result = double.parse(resultStr);

    return result;
  }

  void calculateAndSetCurrency() {
    final setCurrency = ref.read(currencyListProvider.notifier).setCurrency;
    final accountBook = ref.read(accountBookListProvider.notifier);
    final currencyList = ref.watch(currencyListProvider).currencyList;
    final settingNotifier = ref.read(settingProvider.notifier);
    final settings = ref.watch(settingProvider);

    // 숫자 계산
    double result = calculateLeft();

    double exchangeAmount = getExchangedAmount(
      amount: result,
      baseCode: _currentBaseData.currencyCode,
      targetCode: _currentTargetData.currencyCode,
    );

    for (var i = 0; i < currencyList.length; i++) {
      // ignore: unnecessary_null_comparison
      if (currencyList[i] != null) {
        setCurrency(
          targetIndex: i,
          amount: getExchangedAmount(
            amount: result,
            baseCode: _currentBaseData.currencyCode,
            targetCode: currencyModels[currencyList[i].name]!.currencyCode,
          ),
        );
      }
    }

    if (isPageOfAccountBook) {
      if (settings.selectCountryForAnalytics == '') {
        settingNotifier
            .setSelectedCountryForAnalytics(_currentBaseData.countryCode);
      }

      if (accountType == 'exchange' && _controller.text.isNotEmpty) {
        accountBook.addAccountBookList(
          AccountBookModel(
            id: generateRandomKey(),
            targetCurrency: CurrencyCardModel(
                name: _currentTargetData.name, amount: exchangeAmount),
            accountType: accountType,
            subType: 'exchange',
            category: AccountBookBtnModel(
              label: 'exchangeSpend',
              icon: 'swap_horiz', // 환전에 어울리는 아이콘
              color: '#E57373', // 핑크색 (70% 밝기)
            ),
            currency: CurrencyCardModel(
              name: _currentBaseData.name,
              amount: result,
            ),
            isSpend: true,
            createdAt: DateTime.now(),
          ),
        );
        accountBook.addAccountBookList(
          AccountBookModel(
            id: generateRandomKey(),
            targetCurrency: CurrencyCardModel(
              name: _currentTargetData.name,
              amount: result,
            ),
            accountType: accountType,
            subType: 'exchange',
            category: AccountBookBtnModel(
              label: 'exchangeIncome',
              icon: 'swap_horiz', // 환전에 어울리는 아이콘
              color: '#64B5F6', // 파란색 (70% 밝기)
            ),
            currency: CurrencyCardModel(
              name: _currentTargetData.name,
              amount: double.parse(_controller.text),
            ),
            isSpend: false,
            createdAt: DateTime.now(),
          ),
        );
      }

      if (selectedCategory != null && accountType != 'exchange') {
        accountBook.addAccountBookList(
          AccountBookModel(
            id: generateRandomKey(),
            targetCurrency: CurrencyCardModel(
                name: _currentTargetData.name, amount: exchangeAmount),
            accountType: accountType,
            subType: accountType == 'income' ? 'income' : consumptionType,
            category: selectedCategory!,
            currency:
                CurrencyCardModel(name: _currentBaseData.name, amount: result),
            isSpend: accountType != 'income',
            createdAt: DateTime.now(),
          ),
        );
      }
      settingNotifier
          .setCurCurrency(CurrencyCardModel(name: 'none', amount: 0.0));
    } else {
      settingNotifier.setCurCurrency(
          CurrencyCardModel(name: _currentBaseData.name, amount: result));
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).extension<CustomColors>();
    final spendCategories =
        ref.watch(accountBookCategoryProvider).spendCategories;
    final incomeCategories =
        ref.watch(accountBookCategoryProvider).incomeCategories;
    final userCurrencyList = ref.watch(currencyListProvider).currencyList;

    if (selectedCategory == null) {
      setState(() {
        selectedCategory = spendCategories[0];
      });
    }

    if (color == null) {
      return Container();
    }

    return Container(
      decoration: BoxDecoration(
        color: color.containerWhiteBg,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 30.0),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            width: double.infinity,
            color: Colors.transparent,
            constraints: BoxConstraints(
              minHeight: 0,
              maxHeight: (widget.isForAccountOnly == true &&
                      widget.selectedCountry != null)
                  ? 700
                  : 620,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if ((widget.isForAccountOnly == true &&
                    widget.selectedCountry != null))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 18.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: userCurrencyList.asMap().entries.map((entry) {
                          final index = entry.key;
                          final e = entry.value;
                          final countryCode =
                              currencyModels[e.name]!.countryCode;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedCountry = countryCode;
                                _currentBaseData = index == 0
                                    ? currencyModels[userCurrencyList[0].name]!
                                    : currencyModels[e.name]!;
                                _currentTargetData = index == 0
                                    ? currencyModels[userCurrencyList[1].name]!
                                    : currencyModels[userCurrencyList[0].name]!;
                              });
                              // setSelectedCountryForAnalytics(e);
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 5.0),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 6.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: selectedCountry == countryCode
                                    ? Theme.of(context)
                                        .extension<CustomColors>()
                                        ?.greenBg
                                    : const Color.fromARGB(12, 0, 0, 0),
                              ),
                              child: Row(
                                children: [
                                  CountryImage(
                                    language: countryCode,
                                    noStyle: true,
                                  ),
                                  SizedBox(width: 5.0),
                                  Text(
                                    context.tr('countries.${countryCode}'),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: selectedCountry == countryCode
                                          ? Theme.of(context)
                                              .extension<CustomColors>()
                                              ?.greenText
                                          : Theme.of(context)
                                              .extension<CustomColors>()
                                              ?.textGrey,
                                      height: 1.2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                Row(
                  spacing: 3.0,
                  children: [
                    CountryImage(
                      language: _currentBaseData.countryCode,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 0,
                      children: [
                        Text(
                          context
                              .tr('countries.${_currentBaseData.countryCode}'),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            height: 1.0,
                          ),
                        ),
                        Text(
                          _currentBaseData.currencyCode,
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
                    if (isPageOfAccountBook) return;
                    // 왼쪽 또는 오른쪽으로 스와이프 하면 발동
                    if (details.primaryVelocity != 0) {
                      onPressedCalcBtn('backspace');
                    }
                  },
                  onTap: () {
                    if (!isPageOfAccountBook) return;
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
                          _currentBaseData.currencySymbol,
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
                if (!isPageOfAccountBook)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _currentTargetData.currencySymbol,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: color.textGrey,
                        ),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text(
                        formatDouble(getExchangedAmount(
                          amount: double.parse(firstNumSet),
                          baseCode: _currentBaseData.currencyCode,
                          targetCode: _currentTargetData.currencyCode,
                        )),
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: color.textGrey,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                SizedBox(
                  height: 20,
                ),
                if (!isPageOfAccountBook) ...[
                  GridView.count(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: gridList.map((item) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color.fromARGB(255, 136, 164, 180),
                              const Color.fromARGB(255, 76, 84, 130),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              onPressedCalcBtn(item['value'] as String);
                            },
                            child: Center(
                              child: item['label'] is IconData
                                  ? Icon(item['label'] as IconData?,
                                      color: Colors.white, size: 30)
                                  : Text(
                                      item['label'] as String,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
                if (isPageOfAccountBook) ...[
                  Text(
                    context.tr('category.category'),
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
                          isNotMainCategory: true,
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
                                        baseCode: _currentBaseData.currencyCode,
                                        targetCode:
                                            _currentTargetData.currencyCode,
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
                      context.tr('spend_category'),
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
                            isNotMainCategory: true,
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
                      context.tr('exchange_amount'),
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
                        border: Border.all(color: color.textGrey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      style: TextStyle(
                        color: color.opposite, // text color 설정
                      ),
                      suffix: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Text(
                          _currentTargetData.currencySymbol,
                          style: TextStyle(
                            fontSize: 18.0,
                            color: color.textGrey,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                  if (accountType != 'exchange') ...[
                    Text(
                      context.tr('category.category'),
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
                              final end =
                                  (index * 2 + 2) > spendCategories.length
                                      ? spendCategories.length
                                      : index * 2 + 2;
                              final sublist =
                                  spendCategories.sublist(start, end);
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
                SizedBox(height: isPageOfAccountBook ? 30 : 0),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Container(
                        height: 70,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              // 짙은 녹색
                              const Color.fromARGB(255, 30, 161, 69),
                              const Color.fromARGB(255, 68, 161, 96),
                              const Color.fromARGB(255, 102, 211, 134),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextButton(
                          onPressed: () {
                            if (widget.isForAccountBook &&
                                !isPageOfAccountBook) {
                              setState(() {
                                isPageOfAccountBook = !isPageOfAccountBook;
                              });
                              return;
                            }
                            calculateAndSetCurrency();
                            Navigator.pop(context);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 15.0, horizontal: 30.0),
                          ),
                          child: Text(
                            isPageOfAccountBook
                                ? context.tr('calculator.save_account_book')
                                : widget.initialBaseAmountForShortcut is String
                                    ? context
                                        .tr('calculator.go_to_account_book')
                                    : context.tr(
                                        'calculator.calculate_exchange_rate'),
                            style: TextStyle(
                              fontSize: 19,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (!widget.isForAccountBook)
                      Container(
                        margin: EdgeInsets.only(left: 11),
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                            onPressed: () {
                              onPressedCalcBtn('equal');
                              setState(() {
                                isPageOfAccountBook = !isPageOfAccountBook;
                              });
                            },
                            color: Colors.white,
                            icon: Icon(
                              !isPageOfAccountBook
                                  ? Icons.receipt_outlined
                                  : Icons.chevron_left,
                              color: Colors.white,
                              size: 30,
                            )),
                      ),
                    if (widget.isForAccountBook && isPageOfAccountBook)
                      Container(
                        margin: EdgeInsets.only(left: 11),
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                isPageOfAccountBook = !isPageOfAccountBook;
                              });
                            },
                            color: Colors.white,
                            icon: Icon(
                              !isPageOfAccountBook
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
      ),
    );
  }
}
