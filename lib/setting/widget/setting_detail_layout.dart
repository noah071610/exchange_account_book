import 'package:currency_exchange/common/theme/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:currency_exchange/common/layout/default_layout.dart';

class SettingDetailLayout extends ConsumerWidget {
  final List<Widget> child;
  final String? title;
  const SettingDetailLayout({super.key, required this.child, this.title});

  @override
  Widget build(BuildContext context, ref) {
    final appBarHeight = AppBar().preferredSize.height;
    final bottomNavHeight = kBottomNavigationBarHeight;

    return DefaultLayout(
      title: title,
      centerTitle: true,
      child: SingleChildScrollView(
        child: Container(
          color: const Color.fromARGB(8, 0, 0, 0),
          height: MediaQuery.of(context).size.height -
              appBarHeight -
              bottomNavHeight,
          child: title == null
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
                  child: Column(
                    children: child,
                  ),
                )
              : Column(
                  children: child,
                ),
        ),
      ),
    );
  }
}
