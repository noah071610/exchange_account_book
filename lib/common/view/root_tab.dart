import 'package:currency_exchange/analytics/view/analytics_screen.dart';
import 'package:currency_exchange/common/constant/currency_models.dart';
import 'package:currency_exchange/common/provider/currency_list_provider.dart';
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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currencyList = ref.watch(currencyListProvider).currencyList;

    return DefaultLayout(
      floatingButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return CalculatorSheet(
                baseData: currencyModels[currencyList[0].name]!,
                targetData: currencyModels[currencyList[1].name]!,
                initialBaseAmountForShortcut: _controller.index == 0
                    ? currencyList[0].amount.toStringAsFixed(2)
                    : null,
                isForAccountBook: _controller.index != 0,
              );
            },
          );
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 3.0,
        foregroundColor: const Color.fromARGB(255, 72, 29, 147),
        backgroundColor: const Color.fromARGB(255, 245, 242, 252),
        child: Icon(
          Icons.add,
          size: 26.0,
          color: Colors.black38,
        ),
      ),
      title: _controller.index == 0
          ? context.tr('환율 계산기')
          : _controller.index == 1
              ? context.tr('캘린더')
              : _controller.index == 2
                  ? ('$year${context.tr('년')} $month${context.tr('월')}')
                  : context.tr('설정'),
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
          {'icon': FeatherIcons.airplay, 'label': context.tr('환율')},
          {'icon': FeatherIcons.calendar, 'label': context.tr('캘린더')},
          {'icon': FeatherIcons.pieChart, 'label': context.tr('분석')},
          {'icon': FeatherIcons.settings, 'label': context.tr('설정')},
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
            label: context.tr(item['label'] as String),
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
