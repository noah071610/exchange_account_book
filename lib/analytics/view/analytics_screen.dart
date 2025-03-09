import 'package:currency_exchange/common/constant/currency_models.dart';
import 'package:currency_exchange/common/model/account_book_model.dart';
import 'package:currency_exchange/common/provider/account_book_list_provider.dart';
import 'package:currency_exchange/common/widgets/account_book_card.dart';
import 'package:currency_exchange/common/widgets/country_image.dart';
import 'package:currency_exchange/common/widgets/line_chart.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  final String year;
  final String month;

  const AnalyticsScreen({
    super.key,
    required this.year,
    required this.month,
  });

  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  DateTime _selectedDay = DateTime.now();
  bool isShowDetailOfTotal = false;
  int openedIndex = -1;

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

    final DateFormat yearFormatter = DateFormat('yyyy');
    final DateFormat monthFormatter = DateFormat('MM');
    final DateFormat dayFormatter = DateFormat('dd');

    final String year = yearFormatter.format(_selectedDay);
    final String month = monthFormatter.format(_selectedDay);
    final String day = dayFormatter.format(_selectedDay);

    final allListThisMonth = accountBook.accountBookDic[year]?[month]?.values
            .expand((element) => element)
            .toList() ??
        [];

    final Map<String, List<double>> thisMonthDetail = {};
    final List<String> targetCountryCode = allListThisMonth
        .map((e) => e.baseCurrency.countryCode)
        .toSet()
        .toList();

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

    return Column(
      children: [
        Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              if (isShowDetailOfTotal)
                Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    top: 15.0,
                    bottom: 10.0,
                  ),
                  child: Column(
                    children: thisMonthDetail.entries.map((entry) {
                      return Container(
                        margin: EdgeInsets.only(bottom: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              spacing: 3.0,
                              children: [
                                CountryImage(language: entry.key),
                                Text(
                                  '????',
                                  style: TextStyle(
                                    color: Colors.black54,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  entry.value[0].toString(),
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                                Container(
                                  height: 14,
                                  width: 1,
                                  color: Colors.grey,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                ),
                                Text(
                                  entry.value[1].toString(),
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
            ]),
        Expanded(
          // 리스트
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView.builder(
              itemCount: formatWeeks.length,
              itemBuilder: (context, index) {
                final targetDays = formatWeeks[index];
                return WeekItem(
                  targetDays: targetDays,
                  month: month,
                  year: year,
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
                  openedIndex: openedIndex,
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
  final int openedIndex;
  final void Function(int) onTab;

  const WeekItem({
    super.key,
    required this.targetDays,
    required this.year,
    required this.month,
    required this.onTab,
    required this.index,
    required this.openedIndex,
  });

  @override
  ConsumerState<WeekItem> createState() => _WeekItemState();
}

class _WeekItemState extends ConsumerState<WeekItem> {
  @override
  Widget build(BuildContext context) {
    final isExpanded = widget.openedIndex == widget.index;
    final accountBook = ref.watch(accountBookListProvider);

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
              .where((e) => e.isSpend)
              .fold(0, (sum, item) => sum + item.baseCurrency.amount)
          : 0;
      chartList[t == 7 ? 0 : t][1] = spendTargetDay;
      weekIncome = weekIncome +
          (map[d] != null
              ? map[d]!.where((e) => !e.isSpend).fold(
                  0, (sum, item) => sum + item.baseCurrency.amount.toInt())
              : 0);
      weekSpend = weekSpend + spendTargetDay;
    }
    print(map);

    // print(widget.targetDays);

    // final spendList = allListThisMonth.where((item) => item.isSpend).toList();
    // final incomeList = allListThisMonth.where((item) => !item.isSpend).toList();
    // final totalSpend = spendList.fold(
    //     0.0, (sum, item) => sum + item.baseCurrency.displayAmount);
    // final totalIncome = incomeList.fold(
    //     0.0, (sum, item) => sum + item.baseCurrency.displayAmount);

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
                    Text(
                      widget.targetDays.length == 1
                          ? '${widget.month}월 ${widget.targetDays[0]['day']}일'
                          : '${widget.month}월 ${widget.targetDays[0]['day']}일 - ${widget.month}월 ${widget.targetDays[widget.targetDays.length - 1]['day']}일',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: isExpanded ? Colors.black : Colors.black54),
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
                              style: TextStyle(color: Colors.red),
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
                LineChartSample5(
                  allSpots: chartList.map((e) => FlSpot(e[0], e[1])).toList(),
                ),
              ],
            )
        ],
      ),
    );
  }
}
