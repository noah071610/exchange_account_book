import 'package:currency_exchange/exchange/view/exchange_screen.dart';
import 'package:currency_exchange/common/constant/category.dart';
import 'package:currency_exchange/common/provider/category_list_provider.dart';
import 'package:currency_exchange/common/provider/currency_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:currency_exchange/common/widgets/account_book_btn.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:currency_exchange/common/widgets/calculator_sheet.dart';

class DefaultLayout extends ConsumerWidget {
  final String? title;
  final String? bg;
  final Color? color;
  final Widget child;
  final Widget? bottomNavigationBar;
  final Widget? floatingButton;
  final List<Widget>? actions;
  final void Function()? onClickTitle;
  final bool centerTitle;
  final bool? showAppbar;
  final bool bottomSafe;

  const DefaultLayout({
    required this.child,
    this.title,
    this.bg,
    this.color,
    this.bottomNavigationBar,
    this.actions,
    this.onClickTitle,
    this.floatingButton,
    this.centerTitle = false,
    this.showAppbar = true,
    this.bottomSafe = true,
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      floatingActionButton: floatingButton,
      body: Container(
        decoration: BoxDecoration(
          image: bg != null
              ? DecorationImage(
                  image: AssetImage(bg!),
                  fit: BoxFit.cover,
                  opacity: 0.7,
                )
              : null,
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.white
              : Colors.black,
        ),
        child: SafeArea(
          top: true,
          bottom: bottomSafe,
          child: child,
        ),
      ),
      appBar: showAppbar == true ? renderAppbar(context) : null,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  AppBar? renderAppbar(BuildContext context) {
    if (title == null) return null;

    return AppBar(
      elevation: 0,
      title: Text(
        title!,
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
      ),
      actions: actions,
      centerTitle: centerTitle,
    );
  }
}
