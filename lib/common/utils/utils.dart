import 'dart:math';
import 'package:currency_exchange/common/constant/currency_models.dart';
import 'package:currency_exchange/common/model/account_book_btn_model.dart';
import 'package:currency_exchange/common/model/account_book_list_model.dart';
import 'package:currency_exchange/common/model/account_book_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:intl/intl.dart';

String generateRandomKey() {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  return String.fromCharCodes(Iterable.generate(
      7, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
}

Size getTextSize(BuildContext context, String text, TextStyle style) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 1,
    textDirection: ui.TextDirection.ltr,
  )..layout(minWidth: 0, maxWidth: double.infinity);
  return textPainter.size;
}

Widget buildHighlightedText(String text, BuildContext context) {
  final regex = RegExp(r'\{\{(.*?)\}\}');
  final matches = regex.allMatches(text);

  if (matches.isEmpty) {
    return Text(text);
  }

  List<TextSpan> spans = [];
  int lastMatchEnd = 0;

  for (final match in matches) {
    if (match.start > lastMatchEnd) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd, match.start)));
    }
    spans.add(TextSpan(
      text: match.group(1),
      style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
    ));
    lastMatchEnd = match.end;
  }

  if (lastMatchEnd < text.length) {
    spans.add(TextSpan(text: text.substring(lastMatchEnd)));
  }

  return RichText(
    text: TextSpan(
      style: DefaultTextStyle.of(context).style,
      children: spans,
    ),
  );
}

String convertToKoreanNumber(
    double value, BuildContext context, String? currency) {
  if (value == 0) return '0';

  String formattedNumber = value.toStringAsFixed(2); // 소수점 둘째자리까지 남김
  if (formattedNumber.contains('.')) {
    formattedNumber = formattedNumber.replaceAll(RegExp(r'0+$'), '');
    if (formattedNumber.endsWith('.')) {
      formattedNumber =
          formattedNumber.substring(0, formattedNumber.length - 1);
    }
  }

  List<String> parts = formattedNumber.split('.');
  int intValue = int.tryParse(parts[0]) ?? 0;
  String decimalPart = parts.length > 1 ? ".${parts[1]}" : "";

  if (intValue >= 1000000000000) return "$intValue억$decimalPart"; // 억까지만 변환

  List<String> result = [];
  int unitIndex = 0;
  List<String> units = ["", context.tr('suffix.man'), context.tr('suffix.oku')];

  while (intValue > 0 && unitIndex < units.length) {
    int chunk = intValue % 10000;
    if (chunk > 0 || unitIndex == 0) {
      // 0도 표시
      result.insert(0, "$chunk${units[unitIndex]}");
    }
    intValue ~/= 10000;
    unitIndex++;
  }
  String finalResult = result.join() + decimalPart;
  return finalResult +
      (currency == null ? '원' : context.tr('currency.$currency'));
}

double getExchangedAmount({
  required double amount,
  required String baseCode,
  required String targetCode,
  required Map<String, double> exchangeRate,
}) {
  final baseExchange =
      Map<String, double>.from(convertExchangeRates(baseCode, exchangeRate));
  return amount * (baseExchange[targetCode] ?? 1.0);
}

Map<String, double> convertExchangeRates(
    String baseCurrency, Map<String, double> exchangeRate) {
  if (baseCurrency == 'KRW') return exchangeRate;

  if (!exchangeRate.containsKey(baseCurrency)) {
    throw ArgumentError('Invalid currency code');
  }

  double baseRate = exchangeRate[baseCurrency]!;
  Map<String, double> convertedRates = {};

  exchangeRate.forEach((currency, rate) {
    convertedRates[currency] = rate / baseRate;
  });

  return convertedRates;
}

String formatDouble(double value, {bool isDecimal = true}) {
  String result = value.toStringAsFixed(2);
  if (result.endsWith('.00')) {
    result = result.substring(0, result.length - 3);
  }
  if (isDecimal) {
    RegExp regExp = RegExp(r'\B(?=(\d{3})+(?!\d))');
    result = result.replaceAllMapped(regExp, (Match match) => ',');
  }
  return result;
}

Map<String, dynamic> calculateCountryTotals(
    List<AccountBookModel> dayList, String countryCode) {
  final a = dayList.where((e) =>
      currencyModels[e.currency.name]!.countryCode == countryCode && e.isSpend);
  final b = dayList.where((e) =>
      currencyModels[e.currency.name]!.countryCode == countryCode &&
      !e.isSpend);

  final List<List<dynamic>> x = a
      .fold<Map<AccountBookBtnModel, List<dynamic>>>({}, (acc, e) {
        if (acc[e.category] == null) {
          acc[e.category] = [0.0, 0];
        }
        acc[e.category]![0] += e.currency.amount;
        acc[e.category]![1] += 1;
        return acc;
      })
      .entries
      .map((entry) => [entry.key, entry.value[0], entry.value[1]])
      .toList();

  final List<List<dynamic>> y = b
      .fold<Map<AccountBookBtnModel, List<dynamic>>>({}, (acc, e) {
        if (acc[e.category] == null) {
          acc[e.category] = [0.0, 0];
        }
        acc[e.category]![0] += e.currency.amount;
        acc[e.category]![1] += 1;
        return acc;
      })
      .entries
      .map((entry) => [entry.key, entry.value[0], entry.value[1]])
      .toList();

  return {
    'currency': currencyList.firstWhere(
      (model) => model.countryCode == countryCode,
      orElse: () => currencyList[0],
    ),
    'spendSum': a.fold(0.0, (sum, e) => sum + e.currency.amount),
    'spend': x,
    'incomeSum': b.fold(0.0, (sum, e) => sum + e.currency.amount),
    'income': y,
  };
}

List<AccountBookModel> getDailyAccounts(
    DateTime date, Map<String, dynamic> accountBookDic) {
  final DateFormat yearFormatter = DateFormat('yyyy');
  final DateFormat monthFormatter = DateFormat('MM');
  final DateFormat dayFormatter = DateFormat('dd');

  final String year = yearFormatter.format(date);
  final String month = monthFormatter.format(date);
  final String day = dayFormatter.format(date);

  return accountBookDic[year]?[month]?[day] ?? [];
}

List<String> getActiveCountries(
    AccountBookListModel accountBook, String year, String month) {
  final monthMap = accountBook.accountBookDic[year]?[month] ?? {};
  final List<List<String>> temp = [];
  monthMap.forEach((key, value) {
    final List<String> countryCodes = monthMap[key]
            ?.map((e) => currencyModels[e.currency.name]!.countryCode)
            .toSet()
            .toList() ??
        [];
    temp.add(countryCodes);
  });

  return temp.expand((i) => i).toSet().toList();
}

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

void incrementMonthAndYear({required int month, required int year}) {
  if (month == 12) {
    month = 1;
    year++;
  } else {
    month++;
  }
}

void decrementMonthAndYear({required int month, required int year}) {
  if (month == 1) {
    month = 12;
    year--;
  } else {
    month--;
  }
}
