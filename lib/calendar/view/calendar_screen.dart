import 'package:currency_exchange/common/constant/currency_models.dart';
import 'package:currency_exchange/common/provider/account_book_list_provider.dart';
import 'package:currency_exchange/common/widgets/account_book_card.dart';
import 'package:currency_exchange/common/widgets/account_total_by_day.dart';

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
  bool isShowList = true;

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

    final Map<String, Map<String, dynamic>> totalByCountry = {};

    final List<String> countryCodes =
        list.map((item) => item.currency.countryCode).toSet().toList();

    for (var code in countryCodes) {
      totalByCountry[code] = {
        'currency':
            currencyModels.firstWhere((model) => model.countryCode == code),
        'spendSum': list
            .where((e) => e.currency.countryCode == code && e.isSpend)
            .fold(0.0, (sum, e) => sum + e.currency.amount),
        'incomeSum': list
            .where((e) => e.currency.countryCode == code && !e.isSpend)
            .fold(0.0, (sum, e) => sum + e.currency.amount),
      };
    }

    return Column(
      children: [
        Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor:
                        isShowList ? Colors.deepPurpleAccent : Colors.white,
                    foregroundColor: isShowList ? Colors.white : Colors.black54,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      isShowList = true;
                    });
                  },
                  child: Text('리스트 보기',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor:
                        !isShowList ? Colors.deepPurpleAccent : Colors.white,
                    foregroundColor:
                        !isShowList ? Colors.white : Colors.black54,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        topLeft: Radius.circular(0),
                        bottomLeft: Radius.circular(0),
                      ),
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      isShowList = false;
                    });
                  },
                  child: Text('통계 보기',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
        isShowList
            ? Expanded(
                // 리스트
                child: ListView.builder(
                  itemCount: list.length, // 예시로 20개의 아이템을 생성
                  itemBuilder: (context, index) {
                    return AccountBookCard(model: list[index], onTap: (a) {});
                  },
                ),
              )
            : countryCodes.isNotEmpty
                ? Expanded(
                    // 리스트
                    child: ListView.separated(
                      itemCount: countryCodes.length,
                      itemBuilder: (context, index) {
                        if (totalByCountry[countryCodes[index]] == null) {
                          return Container();
                        }
                        return AccountTotalByDay(
                            model: totalByCountry[countryCodes[index]]!);
                      },
                      separatorBuilder: (context, index) => Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Divider(
                            color: Colors.black12,
                            thickness: 1,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
      ],
    );
  }
}


              // GestureDetector(
              //   onTap: () {
              //     setState(() {
              //       isShowDetailOfTotal = !isShowDetailOfTotal;
              //     });
              //   },
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       Expanded(
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Icon(Icons.account_balance_wallet, color: Colors.red),
              //             SizedBox(width: 5),
              //             Text(
              //               '지출: ${formatDouble(totalSpend)}',
              //               style: TextStyle(color: Colors.red),
              //             ),
              //           ],
              //         ),
              //       ),
              //       Container(
              //         height: 20,
              //         width: 1,
              //         color: Colors.grey,
              //       ),
              //       Expanded(
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Icon(Icons.trending_up, color: Colors.blue),
              //             SizedBox(width: 5),
              //             Text(
              //               '수입: ${formatDouble(totalIncome)}',
              //               style: TextStyle(color: Colors.blue),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // if (isShowDetailOfTotal)
              //   Padding(
              //     padding: const EdgeInsets.only(
              //       left: 10.0,
              //       right: 10.0,
              //       top: 15.0,
              //       bottom: 10.0,
              //     ),
              //     child: Column(
              //       children: thisMonthDetail.entries.map((entry) {
              //         return Container(
              //           margin: EdgeInsets.only(bottom: 5.0),
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               Row(
              //                 crossAxisAlignment: CrossAxisAlignment.center,
              //                 spacing: 3.0,
              //                 children: [
              //                   CountryImage(language: entry.key),
              //                   Text(
              //                     '?????',
              //                     style: TextStyle(
              //                       color: Colors.black54,
              //                     ),
              //                   )
              //                 ],
              //               ),
              //               Row(
              //                 crossAxisAlignment: CrossAxisAlignment.center,
              //                 children: [
              //                   Text(
              //                     entry.value[0].toString(),
              //                     style: TextStyle(
              //                       color: Colors.red,
              //                     ),
              //                   ),
              //                   Container(
              //                     height: 14,
              //                     width: 1,
              //                     color: Colors.grey,
              //                     margin: EdgeInsets.symmetric(horizontal: 5.0),
              //                   ),
              //                   Text(
              //                     entry.value[1].toString(),
              //                     style: TextStyle(
              //                       color: Colors.blue,
              //                     ),
              //                   )
              //                 ],
              //               )
              //             ],
              //           ),
              //         );
              //       }).toList(),
              //     ),
              //   ),