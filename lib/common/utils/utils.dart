import 'dart:math';
import 'package:currency_exchange/common/constant/temp.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

String generateRandomKey() {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  return String.fromCharCodes(Iterable.generate(
      12, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
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

String convertToKoreanNumber(double value, BuildContext context) {
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
  return finalResult;
}

double getExchangedAmount({
  required double amount,
  required String baseCode,
  required String targetCode,
}) {
  final baseExchange = Map<String, double>.from(convertExchangeRates(baseCode));
  return amount * (baseExchange[targetCode] ?? 1.0);
}

Map<String, double> convertExchangeRates(String baseCurrency) {
  if (baseCurrency == 'KRW') return exchange;

  if (!exchange.containsKey(baseCurrency)) {
    throw ArgumentError('Invalid currency code');
  }

  double baseRate = exchange[baseCurrency]!;
  Map<String, double> convertedRates = {};

  exchange.forEach((currency, rate) {
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
