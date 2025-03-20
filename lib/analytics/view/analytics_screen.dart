import 'package:currency_exchange/analytics/widget/week_item.dart';
import 'package:currency_exchange/common/provider/account_book_list_provider.dart';
import 'package:currency_exchange/common/provider/setting_provider.dart';
import 'package:currency_exchange/common/theme/custom_colors.dart';
import 'package:currency_exchange/common/utils/utils.dart';
import 'package:currency_exchange/common/widgets/account_total_by_day.dart';
import 'package:currency_exchange/common/widgets/country_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  final String year;
  final String month;
  int? openedIndex;
  final Function(bool isLeft) onSwipe;

  AnalyticsScreen({
    super.key,
    required this.year,
    required this.month,
    required this.onSwipe,
    this.openedIndex,
  });

  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  bool isShowDetailOfTotal = false;

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
    print(widget.year);
    print(widget.month);
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
    if (todayIndex != -1) widget.openedIndex ??= todayIndex;

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
                      if (widget.openedIndex == i) {
                        widget.openedIndex = -1;
                      } else {
                        widget.openedIndex = i;
                      }
                    });
                  },
                  index: index,
                  openedIndex: widget.openedIndex ?? -1,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
