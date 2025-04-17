import 'package:currency_exchange/analytics/view/analytics_screen.dart';
import 'package:currency_exchange/common/constant/currency_models.dart';
import 'package:currency_exchange/common/model/exchange_rate_model.dart';
import 'package:currency_exchange/common/provider/currency_list_provider.dart';
import 'package:currency_exchange/common/provider/exchange_rate_provider.dart';
import 'package:currency_exchange/common/provider/setting_provider.dart';
import 'package:currency_exchange/common/widgets/calculator_sheet.dart';
import 'package:currency_exchange/exchange/view/exchange_screen.dart';
import 'package:currency_exchange/calendar/view/calendar_screen.dart';
import 'package:currency_exchange/setting/view/setting_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:currency_exchange/common/layout/default_layout.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class RootTab extends ConsumerStatefulWidget {
  const RootTab({
    super.key,
  });

  @override
  ConsumerState<RootTab> createState() => _RootTabState();
}

class _RootTabState extends ConsumerState<RootTab>
    with SingleTickerProviderStateMixin {
  late TabController _controller;
  final PageController pageController = PageController();
  int year = int.parse(DateFormat('yyyy').format(DateTime.now()));
  int month = int.parse(DateFormat('MM').format(DateTime.now()));
  int? openedIndex;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 4, vsync: this);

    // API 호출
    fetchExchangeData();
  }

  Future<void> fetchExchangeData() async {
    try {
      final now = DateTime.now();
      final date = DateFormat('yyyy-MM-dd').format(now);

      final response = await http
          .get(Uri.parse('http://localhost:5555/api/exchange?date=$date'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final Map<String, dynamic> exchangeRateDynamic = data['json'];
        final Map<String, double> exchangeRate = exchangeRateDynamic
            .map((key, value) => MapEntry(key, value.toDouble()));
        await ref
            .read(exchangeRateProvider.notifier)
            .updateExchangeRate(ExchangeRateModel(map: exchangeRate));
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyList = ref.watch(currencyListProvider).currencyList;
    final curCurrency = ref.watch(settingProvider).curCurrency;

    return DefaultLayout(
      floatingActionButton: _controller.index == 1
          ? FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return CalculatorSheet(
                      baseData: currencyModels[currencyList[0].name]!,
                      targetData: currencyModels[currencyList[1].name]!,
                      initialBaseAmountForShortcut: '0',
                      isForAccountBook: true,
                      isForAccountOnly: true,
                      selectedCountry:
                          currencyModels[currencyList[0].name]!.countryCode,
                    );
                  },
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              elevation: 3.0,
              child: Icon(
                Icons.add,
                size: 26.0,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black38
                    : Colors.white,
              ),
            )
          : curCurrency?.name != 'none' &&
                  curCurrency != null &&
                  _controller.index == 0
              ? FloatingActionButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return CalculatorSheet(
                          baseData: currencyModels[curCurrency.name]!,
                          targetData: currencyModels[currencyList[0].name]!,
                          initialBaseAmountForShortcut:
                              curCurrency.amount.toStringAsFixed(2),
                          isForAccountBook: true,
                          selectedCountry: null,
                        );
                      },
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 3.0,
                  child: Icon(
                    Icons.add,
                    size: 26.0,
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black38
                        : Colors.white,
                  ),
                )
              : null,
      title: _controller.index == 0
          ? context.tr('exchange_calculator')
          : _controller.index == 1
              ? context.tr('calendar.calendar')
              : _controller.index == 2
                  ? ('$year${context.tr('year')} ${context.tr('month.$month')}')
                  : context.tr('settings.settings'),
      centerTitle: true,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _controller.index,
        onTap: (newIndex) {
          setState(() {
            _controller.index = newIndex;
          });
        },
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        selectedLabelStyle: TextStyle(fontSize: 12),
        unselectedLabelStyle: TextStyle(fontSize: 12),
        items: [
          {'icon': FeatherIcons.airplay, 'label': context.tr('exchange')},
          {
            'icon': FeatherIcons.calendar,
            'label': context.tr('calendar.calendar')
          },
          {'icon': FeatherIcons.pieChart, 'label': context.tr('analytics')},
          {
            'icon': FeatherIcons.settings,
            'label': context.tr('settings.settings')
          },
        ].map((item) {
          return BottomNavigationBarItem(
            icon: Column(
              children: [
                Icon(
                  item['icon'] as IconData?,
                  size: 23.0,
                ),
                SizedBox(
                  height: 3.0,
                )
              ],
            ),
            label: item['label'] as String,
          );
        }).toList(),
      ),
      leading: _controller.index == 2
          ? IconButton(
              icon: Icon(Icons.chevron_left),
              onPressed: () {
                setState(() {
                  if (month == 1) {
                    month = 12;
                    year--;
                  } else {
                    month--;
                  }
                  openedIndex = null;
                });
              },
            )
          : null,
      actions: _controller.index == 0
          ? [
              IconButton(
                icon: Icon(FeatherIcons.settings, size: 20),
                onPressed: () {
                  context.go('/currency-setting');
                },
              ),
            ]
          : _controller.index == 2
              ? [
                  IconButton(
                    icon: Icon(Icons.chevron_right),
                    onPressed: () {
                      setState(() {
                        if (month == 12) {
                          month = 1;
                          year++;
                        } else {
                          month++;
                        }
                        openedIndex = null;
                      });
                    },
                  ),
                ]
              : [],
      child: TabBarView(
        controller: _controller,
        physics: NeverScrollableScrollPhysics(),
        children: [
          ExchangeScreen(),
          CalenderScreen(),
          AnalyticsScreen(
              openedIndex: openedIndex,
              month: month < 10 ? '0$month' : month.toString(),
              year: year.toString(),
              onSwipe: (isLeft) {
                setState(() {
                  if (isLeft) {
                    if (month == 1) {
                      month = 12;
                      year--;
                    } else {
                      month--;
                    }
                    openedIndex = null;
                  } else {
                    if (month == 12) {
                      month = 1;
                      year++;
                    } else {
                      month++;
                    }
                    openedIndex = null;
                  }
                });
              }),
          SettingScreen(),
        ],
      ),
    );
  }
}
