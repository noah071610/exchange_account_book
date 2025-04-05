import 'package:currency_exchange/common/constant/currency_models.dart';
import 'package:currency_exchange/common/provider/account_book_list_provider.dart';
import 'package:currency_exchange/common/provider/setting_provider.dart';
import 'package:currency_exchange/common/theme/custom_colors.dart';
import 'package:currency_exchange/common/widgets/line_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
