import 'dart:math';
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
