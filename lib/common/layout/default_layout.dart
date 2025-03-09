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
  final List<Widget>? actions;
  final void Function()? onClickTitle;
  final bool centerTitle;
  final bool? showAppbar;

  const DefaultLayout({
    required this.child,
    this.title,
    this.bg,
    this.color,
    this.bottomNavigationBar,
    this.actions,
    this.onClickTitle = null,
    this.centerTitle = false,
    this.showAppbar = true,
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final currencyList = ref.watch(currencyListProvider);

    return Scaffold(
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () {
      //     showModalBottomSheet(
      //       context: context,
      //       isScrollControlled: true,
      //       builder: (BuildContext context) {
      //         return CalculatorSheet(
      //           baseData: currencyList.basePair.baseCurrency,
      //           targetData: currencyList.basePair.targetCurrency,
      //           initialBaseAmountForShortcut:
      //               currencyList.basePair.baseCurrency.inputAmount.toString(),
      //         );
      //       },
      //     );
      //   },
      //   label: Text(
      //     '현재 금액을 가계부에 추가',
      //     style: TextStyle(fontSize: 15),
      //   ),
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(30.0),
      //   ),
      //   extendedPadding: EdgeInsets.all(50.0),
      //   elevation: 3.0,
      //   foregroundColor: const Color.fromARGB(255, 72, 29, 147),
      //   backgroundColor: const Color.fromARGB(255, 245, 242, 252),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
          bottom: true,
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
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      actions: actions,
      centerTitle: centerTitle,
    );
  }
}
