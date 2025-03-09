import 'package:currency_exchange/analytics/view/analytics_screen.dart';
import 'package:currency_exchange/exchange/view/exchange_screen.dart';
import 'package:currency_exchange/calendar/view/calendar_screen.dart';
import 'package:currency_exchange/setting/view/setting_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:currency_exchange/common/layout/default_layout.dart';
import 'package:flutter/cupertino.dart';

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
    return DefaultLayout(
      title: context.tr('안녕세계'),
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
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontSize: 12),
        unselectedLabelStyle: TextStyle(fontSize: 12),
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.library_books), label: context.tr('ㅇㅇ')),
          BottomNavigationBarItem(
              icon: Icon(Icons.book), label: context.tr('list')),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.push_pin,
              ),
              label: context.tr('favorites')),
          BottomNavigationBarItem(
              icon: Icon(Icons.bookmark), label: context.tr('appendix')),
        ],
      ),
      actions: [],
      child: TabBarView(
        controller: _controller,
        physics: NeverScrollableScrollPhysics(),
        children: [
          ExchangeScreen(),
          CalenderScreen(),
          AnalyticsScreen(
            month: '03',
            year: '2025',
          ),
          SettingScreen(),
        ],
      ),
    );
  }
}
