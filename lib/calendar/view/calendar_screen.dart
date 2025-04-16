import 'package:currency_exchange/common/constant/currency_models.dart';
import 'package:currency_exchange/common/model/account_book_model.dart';
import 'package:currency_exchange/common/provider/account_book_list_provider.dart';
import 'package:currency_exchange/common/provider/currency_list_provider.dart';
import 'package:currency_exchange/common/provider/setting_provider.dart';
import 'package:currency_exchange/common/theme/custom_colors.dart';
import 'package:currency_exchange/common/utils/utils.dart';
import 'package:currency_exchange/common/widgets/account_book_card.dart';
import 'package:currency_exchange/common/widgets/account_total_by_day.dart';
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
  bool isShowList = true;
  List<String> selectedCountries = [];

  @override
  Widget build(BuildContext context) {
    final accountBook = ref.watch(accountBookListProvider);
    final currencyList = ref.watch(currencyListProvider).currencyList;

    final DateFormat yearFormatter = DateFormat('yyyy');
    final DateFormat monthFormatter = DateFormat('MM');

    final dailyAccounts =
        getDailyAccounts(_selectedDay, accountBook.accountBookDic);

    final Map<String, Map<String, dynamic>> totalByCountry = {};

    List<String> countryCodes = ([
      ...dailyAccounts
          .map((item) => currencyModels[item.currency.name]!.countryCode),
    ]).toSet().toList();

    for (var code in countryCodes) {
      totalByCountry[code] = calculateCountryTotals(dailyAccounts, code);
    }

    return Column(
      children: [
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black12,
                    width: 1.0,
                  ),
                ),
              ),
              child: TableCalendar(
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _selectedDay,
                calendarStyle: CalendarStyle(
                  todayDecoration: BoxDecoration(
                    color: Theme.of(context)
                        .extension<CustomColors>()
                        ?.primaryBg, // 현재 날짜 색깔
                    shape: BoxShape.circle,
                  ),
                  todayTextStyle: TextStyle(
                      color: Theme.of(context)
                          .extension<CustomColors>()
                          ?.opposite),
                  selectedDecoration: BoxDecoration(
                    color: Theme.of(context)
                        .extension<CustomColors>()
                        ?.primary, // 포커스 된 날짜 색깔
                    shape: BoxShape.circle,
                  ),
                  selectedTextStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) => setState(() {
                  _selectedDay = selectedDay; // 선택된 달 업데이트
                }),
                calendarFormat: _calendarFormat, // 변경된 포맷 사용
                // onFormatChanged: (format) {
                //   setState(() {
                //     _calendarFormat = format; // 포맷 변경 시 선택된 날짜 유지
                //   });
                // },
                // onPageChanged: (d) {
                //   print(d);
                //   _selectedDay = d;
                // },
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true, // 제목을 가운데 정렬
                ),
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    final DateFormat dayFormatter = DateFormat('dd');

                    final String year = yearFormatter.format(date);
                    final String month = monthFormatter.format(date);
                    final String day = dayFormatter.format(date);

                    final List<AccountBookModel> list =
                        accountBook.accountBookDic[year]?[month]?[day] ?? [];
                    if (list.isNotEmpty) {
                      return Positioned(
                        right: 7,
                        bottom: 7,
                        child: Container(
                          width: 7.0,
                          height: 7.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.pink,
                          ),
                        ),
                      );
                    }

                    return null;
                  },
                ),
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
                  width: 140.0,
                  height: 25.0,
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.drag_handle,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        if (dailyAccounts.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(
                left: 12.0, right: 12.0, top: 8.0, bottom: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: isShowList
                          ? Theme.of(context).extension<CustomColors>()?.primary
                          : const Color.fromARGB(14, 0, 0, 0),
                      foregroundColor: isShowList
                          ? Colors.white
                          : Theme.of(context)
                              .extension<CustomColors>()
                              ?.textGrey,
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
                    child: Text(context.tr('calendar.view_list'),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: !isShowList
                          ? Theme.of(context).extension<CustomColors>()?.primary
                          : const Color.fromARGB(14, 0, 0, 0),
                      foregroundColor: !isShowList
                          ? Colors.white
                          : Theme.of(context)
                              .extension<CustomColors>()
                              ?.textGrey,
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
                    child: Text(context.tr('calendar.view_statistics'),
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        // if (isShowList && dailyAccounts.isNotEmpty)
        //   Padding(
        //     padding:
        //         const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 8.0),
        //     child: SingleChildScrollView(
        //       scrollDirection: Axis.horizontal,
        //       child: Row(
        //         children: countryCodes
        //             .map(
        //               (e) => GestureDetector(
        //                 onTap: () {
        //                   setSelectedCountriesForCalendar(e);
        //                 },
        //                 child: Container(
        //                   margin: EdgeInsets.symmetric(horizontal: 2.5),
        //                   padding: EdgeInsets.symmetric(
        //                       horizontal: 14, vertical: 5.0),
        //                   decoration: BoxDecoration(
        //                     borderRadius: BorderRadius.circular(4),
        //                     color: countryCodes.contains(e)
        //                         ? Theme.of(context)
        //                             .extension<CustomColors>()
        //                             ?.greenBg
        //                         : Theme.of(context)
        //                             .extension<CustomColors>()
        //                             ?.containerBg,
        //                   ),
        //                   child: Row(
        //                     children: [
        //                       CountryImage(
        //                         language: e,
        //                         noStyle: true,
        //                       ),
        //                       SizedBox(width: 5.0),
        //                       Text(
        //                         context.tr('countries.$e'),
        //                         style: TextStyle(
        //                           fontSize: 14,
        //                           fontWeight: FontWeight.w600,
        //                           color: countryCodes.contains(e)
        //                               ? Theme.of(context)
        //                                   .extension<CustomColors>()
        //                                   ?.greenText
        //                               : Theme.of(context)
        //                                   .extension<CustomColors>()
        //                                   ?.textGrey,
        //                           height: 1.2,
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //               ),
        //             )
        //             .toList(),
        //       ),
        //     ),
        //   ),
        if (dailyAccounts.isEmpty)
          Container(
            height: 150,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 50,
                ),
                SizedBox(height: 10),
                Text(
                  context.tr('calendar.empty_account'),
                  style: TextStyle(
                    fontSize: 16,
                    color:
                        Theme.of(context).extension<CustomColors>()?.textGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        isShowList
            ? Expanded(
                // 리스트
                child: ListView.builder(
                  itemCount: dailyAccounts.length, // 예시로 20개의 아이템을 생성
                  itemBuilder: (context, index) {
                    return AccountBookCard(
                        model: dailyAccounts[index], onTap: (a) {});
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
