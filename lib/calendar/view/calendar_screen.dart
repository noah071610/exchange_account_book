import 'package:currency_exchange/common/constant/currency_models.dart';
import 'package:currency_exchange/common/provider/account_book_list_provider.dart';
import 'package:currency_exchange/common/widgets/account_book_card.dart';
import 'package:currency_exchange/common/widgets/country_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderScreen extends ConsumerStatefulWidget {
  const CalenderScreen({
    super.key,
  });

  @override
  _CalenderScreenState createState() => _CalenderScreenState();
}

class _CalenderScreenState extends ConsumerState<CalenderScreen> {
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week; // 초기 포맷 설정
  bool isShowDetailOfTotal = false;

  @override
  Widget build(BuildContext context) {
    final accountBook = ref.watch(accountBookListProvider);

    final DateFormat yearFormatter = DateFormat('yyyy');
    final DateFormat monthFormatter = DateFormat('MM');
    final DateFormat dayFormatter = DateFormat('dd');

    final String year = yearFormatter.format(_selectedDay);
    final String month = monthFormatter.format(_selectedDay);
    final String day = dayFormatter.format(_selectedDay);

    final list = accountBook.accountBookDic[year]?[month]?[day] ?? [];

    final allListThisMonth = accountBook.accountBookDic[year]?[month]?.values
            .expand((element) => element)
            .toList() ??
        [];

    final spendList = allListThisMonth.where((item) => item.isSpend).toList();
    final incomeList = allListThisMonth.where((item) => !item.isSpend).toList();
    final totalSpend =
        spendList.fold(0.0, (sum, item) => sum + item.baseCurrency.amount);
    final totalIncome =
        incomeList.fold(0.0, (sum, item) => sum + item.baseCurrency.amount);

    final Map<String, List<double>> thisMonthDetail = {};
    final List<String> targetCountryCode = allListThisMonth
        .map((e) => e.baseCurrency.countryCode)
        .toSet()
        .toList();

    if (isShowDetailOfTotal) {
      if (_calendarFormat == CalendarFormat.month) {
        setState(() {
          _calendarFormat = CalendarFormat.week;
        });
      }
      for (var i = 0; i < targetCountryCode.length; i++) {
        final spendListSpecific = spendList
            .where((e) => e.baseCurrency.countryCode == targetCountryCode[i]);
        final totalSpendSpecific = spendListSpecific.fold(
            0.0, (sum, item) => sum + item.baseCurrency.amount);
        final incomeListSpecific = incomeList
            .where((e) => e.baseCurrency.countryCode == targetCountryCode[i]);
        final totalIncomeSpecific = incomeListSpecific.fold(
            0.0, (sum, item) => sum + item.baseCurrency.amount);
        thisMonthDetail[targetCountryCode[i]] = [
          totalSpendSpecific,
          totalIncomeSpecific
        ];
      }
    }

    return Column(
      children: [
        Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isShowDetailOfTotal = !isShowDetailOfTotal;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.account_balance_wallet, color: Colors.red),
                          SizedBox(width: 5),
                          Text(
                            '지출: $totalSpend',
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
                            '수입: $totalIncome',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
                                  '?????',
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
              TableCalendar(
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _selectedDay,
                calendarStyle: CalendarStyle(),
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) => setState(() {
                  _selectedDay = selectedDay; // 선택된 달 업데이트
                }),
                calendarFormat: _calendarFormat, // 변경된 포맷 사용
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                ),
              ),
              Container(
                child: GestureDetector(
                  onVerticalDragUpdate: (details) {
                    if (details.primaryDelta! > 0) {
                      // 아래로 스와이프
                      setState(() {
                        _calendarFormat = CalendarFormat.month;
                      });
                      if (isShowDetailOfTotal) {
                        isShowDetailOfTotal = false;
                      }
                    } else if (details.primaryDelta! < 0) {
                      // 위로 스와이프
                      setState(() {
                        _calendarFormat = CalendarFormat.week;
                      });
                    }
                  },
                  child: Container(
                    width: 150.0,
                    height: 30.0,
                    color: Colors.amber,
                    child: Container(),
                  ),
                ),
              )
            ]),
        Expanded(
          // 리스트
          child: ListView.builder(
            itemCount: list.length, // 예시로 20개의 아이템을 생성
            itemBuilder: (context, index) {
              return AccountBookCard(model: list[index], onTap: (a) {});
            },
          ),
        ),
      ],
    );
  }
}
