import 'package:currency_exchange/common/constant/currency_models.dart';
import 'package:currency_exchange/common/provider/account_book_list_provider.dart';
import 'package:currency_exchange/common/provider/setting_provider.dart';
import 'package:currency_exchange/common/theme/custom_colors.dart';
import 'package:currency_exchange/common/utils/utils.dart';
import 'package:currency_exchange/common/widgets/account_total_by_day.dart';
import 'package:currency_exchange/common/widgets/country_image.dart';
import 'package:currency_exchange/common/widgets/line_chart.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  final String year;
  final String month;
  final Function(bool isLeft) onSwipe;

  const AnalyticsScreen({
    super.key,
    required this.year,
    required this.month,
    required this.onSwipe,
  });

  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  bool isShowDetailOfTotal = false;
  int? openedIndex;

  List<List<DateTime>> getWeeksInMonth(int year, int month) {
    List<List<DateTime>> weeks = [];
    DateTime firstDayOfMonth = DateTime(year, month, 1);
    DateTime lastDayOfMonth = DateTime(year, month + 1, 0);

    DateTime currentDay = firstDayOfMonth;
    while (currentDay.weekday != DateTime.sunday) {
      currentDay = currentDay.subtract(Duration(days: 1));
    }

    while (currentDay.isBefore(lastDayOfMonth) ||
        currentDay.isAtSameMomentAs(lastDayOfMonth)) {
      List<DateTime> week = [];
      for (int i = 0; i < 7; i++) {
        if (currentDay.isAfter(lastDayOfMonth)) break;
        week.add(currentDay);
        currentDay = currentDay.add(Duration(days: 1));
      }
      weeks.add(week);
    }

    return weeks;
  }

  @override
  Widget build(BuildContext context) {
    final accountBook = ref.watch(accountBookListProvider);
    final setSelectedCountryForAnalytics =
        ref.read(settingProvider.notifier).setSelectedCountryForAnalytics;
    final selectCountryForAnalytics =
        ref.watch(settingProvider).selectCountryForAnalytics;

    final allListByMonth = accountBook
            .accountBookDic[widget.year]?[widget.month]?.values
            .expand((element) => element)
            .toList() ??
        [];
    final monthTotalModel =
        calculateCountryTotals(allListByMonth, selectCountryForAnalytics);
    final List<String> activeCountries =
        getActiveCountries(accountBook, widget.year, widget.month);

    // 예시로 주어진 연도와 월을 사용하여 주 목록을 생성
    List<List<DateTime>> weeks =
        getWeeksInMonth(int.parse(widget.year), int.parse(widget.month));
    final List<List<Map<String, dynamic>>> formatWeeks = weeks.map((e) {
      List<DateTime> target = List.from(e);
      target.removeWhere((day) => day.month != int.parse(widget.month));
      return target
          .map((k) =>
              {'day': DateFormat('dd').format(k), 'weekDay': k.weekday.toInt()})
          .toList();
    }).toList();

    int todayIndex = -1;

    if (int.parse(DateFormat('MM').format(DateTime.now())) ==
        int.parse(widget.month)) {
      for (int i = 0; i < formatWeeks.length; i++) {
        for (int j = 0; j < formatWeeks[i].length; j++) {
          if (formatWeeks[i][j]['day'] ==
              DateFormat('dd').format(DateTime.now())) {
            todayIndex = i;
            break;
          }
        }
        if (todayIndex != -1) break;
      }
    }
    if (todayIndex != -1) openedIndex ??= todayIndex;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
          child: Row(
            spacing: 5.0,
            children: activeCountries
                .map(
                  (e) => GestureDetector(
                    onTap: () {
                      setSelectedCountryForAnalytics(e);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 6.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: selectCountryForAnalytics == e
                            ? Theme.of(context)
                                .extension<CustomColors>()
                                ?.greenBg
                            : const Color.fromARGB(12, 0, 0, 0),
                      ),
                      child: Row(
                        spacing: 5.0,
                        children: [
                          CountryImage(
                            language: e,
                            noStyle: true,
                          ),
                          Text(
                            context.tr('countries.$e'),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: selectCountryForAnalytics == e
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
                  ),
                )
                .toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
          child: AccountTotalByDay(model: monthTotalModel),
        ),
        Expanded(
          // 리스트
          child: Padding(
            padding:
                const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
            child: ListView.builder(
              itemCount: formatWeeks.length,
              itemBuilder: (context, index) {
                final targetDays = formatWeeks[index];
                return WeekItem(
                  targetDays: targetDays,
                  month: widget.month,
                  year: widget.year,
                  isToday: todayIndex == index,
                  onTab: (int i) {
                    setState(() {
                      if (openedIndex == i) {
                        openedIndex = -1;
                      } else {
                        openedIndex = i;
                      }
                    });
                  },
                  index: index,
                  openedIndex: openedIndex ?? -1,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class WeekItem extends ConsumerStatefulWidget {
  final List<Map<String, dynamic>> targetDays;
  final String year;
  final String month;
  final int index;
  final bool isToday;
  final int openedIndex;
  final void Function(int) onTab;

  const WeekItem({
    super.key,
    required this.targetDays,
    required this.year,
    required this.month,
    required this.isToday,
    required this.onTab,
    required this.index,
    required this.openedIndex,
  });

  @override
  ConsumerState<WeekItem> createState() => _WeekItemState();
}

class _WeekItemState extends ConsumerState<WeekItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isExpanded = widget.openedIndex == widget.index;
    final accountBook = ref.watch(accountBookListProvider);
    final selectCountryForAnalytics =
        ref.watch(settingProvider).selectCountryForAnalytics;

    final map = accountBook.accountBookDic[widget.year]?[widget.month] ?? {};

    final List<List<double>> chartList = [
      [0, 0],
      [1, 0],
      [2, 0],
      [3, 0],
      [4, 0],
      [5, 0],
      [6, 0]
    ];

    double weekSpend = 0;
    double weekIncome = 0;

    for (var i = 0; i < widget.targetDays.length; i++) {
      final t = widget.targetDays[i]['weekDay'];
      final d = widget.targetDays[i]['day'];
      final double spendTargetDay = map[d] != null
          ? map[d]!
              .where((e) =>
                  e.isSpend &&
                  selectCountryForAnalytics ==
                      currencyModels[e.currency.name]!.countryCode)
              .fold(0, (sum, item) => sum + item.currency.amount)
          : 0;
      chartList[t == 7 ? 0 : t][1] = spendTargetDay;
      weekIncome = weekIncome +
          (map[d] != null
              ? map[d]!
                  .where((e) =>
                      !e.isSpend &&
                      selectCountryForAnalytics ==
                          currencyModels[e.currency.name]!.countryCode)
                  .fold(0, (sum, item) => sum + item.currency.amount.toInt())
              : 0);
      weekSpend = weekSpend + spendTargetDay;
    }

    // print(widget.targetDays);

    // final spendList = allListThisMonth.where((item) => item.isSpend).toList();
    // final incomeList = allListThisMonth.where((item) => !item.isSpend).toList();
    // final totalSpend = spendList.fold(
    //     0.0, (sum, item) => sum + item.currency.displayAmount);
    // final totalIncome = incomeList.fold(
    //     0.0, (sum, item) => sum + item.currency.displayAmount);

    return GestureDetector(
      onTap: () {
        widget.onTab(widget.index);
      },
      child: Column(
        children: [
          Container(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black12,
                    width: isExpanded ? 0 : 1.0,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10.0, vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      spacing: 3.0,
                      children: [
                        Text(
                          widget.targetDays.length == 1
                              ? '${widget.month}월 ${widget.targetDays[0]['day']}일'
                              : '${widget.month}월 ${widget.targetDays[0]['day']}일 - ${widget.month}월 ${widget.targetDays[widget.targetDays.length - 1]['day']}일',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: isExpanded
                                  ? null
                                  : Theme.of(context)
                                      .extension<CustomColors>()
                                      ?.textGrey),
                        ),
                        if (widget.isToday)
                          Icon(
                            Icons.star,
                            color: const Color.fromARGB(255, 246, 221, 1),
                            size: 18,
                          ),
                      ],
                    ),
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isExpanded)
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {});
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.account_balance_wallet,
                                color: Colors.red),
                            SizedBox(width: 5),
                            Text(
                              '지출: $weekSpend',
                              style: TextStyle(color: Colors.redAccent),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 20,
                        width: 1,
                        color: Colors.grey,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.trending_up, color: Colors.blue),
                            SizedBox(width: 5),
                            Text(
                              '수입: $weekIncome',
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                AnalyticsChart(
                  allSpots: chartList.map((e) => FlSpot(e[0], e[1])).toList(),
                  highest: chartList
                      .map((e) => e[1].toInt())
                      .reduce((a, b) => a > b ? a : b),
                ),
              ],
            )
        ],
      ),
    );
  }
}
