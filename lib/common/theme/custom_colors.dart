import 'package:flutter/material.dart';

class CustomColors extends ThemeExtension<CustomColors> {
  final Color primary;
  final Color sub;
  final Color text;
  final Color active;
  final Color icon;
  final Color primaryBg;
  final Color containerBg;
  final Color containerWhiteBg;
  final Color buttonBackground;
  final Color buttonTextColor;
  final Color divider100;
  final Color textGrey;
  final Color opposite;
  final Color greenBg; // 추가된 요소
  final Color greenText; // 추가된 요소

  CustomColors({
    required this.primary,
    required this.sub,
    required this.text,
    required this.active,
    required this.icon,
    required this.containerBg,
    required this.buttonBackground,
    required this.buttonTextColor,
    required this.primaryBg,
    required this.divider100,
    required this.textGrey,
    required this.containerWhiteBg,
    required this.opposite,
    required this.greenBg, // 추가된 요소
    required this.greenText, // 추가된 요소
  });

  @override
  ThemeExtension<CustomColors> copyWith({
    Color? primary,
    Color? sub,
    Color? text,
    Color? active,
    Color? icon,
    Color? containerBg,
    Color? buttonBackground,
    Color? buttonTextColor,
    Color? primaryBg,
    Color? divider100,
    Color? textGrey,
    Color? containerWhiteBg,
    Color? opposite,
    Color? greenBg, // 추가된 요소
    Color? greenText, // 추가된 요소
  }) {
    return CustomColors(
      primary: primary ?? this.primary,
      sub: sub ?? this.sub,
      text: text ?? this.text,
      active: active ?? this.active,
      icon: icon ?? this.icon,
      containerBg: containerBg ?? this.containerBg,
      buttonBackground: buttonBackground ?? this.buttonBackground,
      buttonTextColor: buttonTextColor ?? this.buttonTextColor,
      primaryBg: primaryBg ?? this.primaryBg,
      divider100: divider100 ?? this.divider100,
      textGrey: textGrey ?? this.textGrey,
      containerWhiteBg: containerWhiteBg ?? this.containerWhiteBg,
      opposite: opposite ?? this.opposite,
      greenBg: greenBg ?? this.greenBg, // 추가된 요소
      greenText: greenText ?? this.greenText, // 추가된 요소
    );
  }

  @override
  ThemeExtension<CustomColors> lerp(
      ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      primary: Color.lerp(primary, other.primary, t)!,
      sub: Color.lerp(sub, other.sub, t)!,
      text: Color.lerp(text, other.text, t)!,
      active: Color.lerp(active, other.active, t)!,
      icon: Color.lerp(icon, other.icon, t)!,
      containerBg: Color.lerp(containerBg, other.containerBg, t)!,
      buttonBackground:
          Color.lerp(buttonBackground, other.buttonBackground, t)!,
      buttonTextColor: Color.lerp(buttonTextColor, other.buttonTextColor, t)!,
      primaryBg: Color.lerp(primaryBg, other.primaryBg, t)!,
      divider100: Color.lerp(divider100, other.divider100, t)!,
      textGrey: Color.lerp(textGrey, other.textGrey, t)!,
      opposite: Color.lerp(opposite, other.opposite, t)!,
      containerWhiteBg:
          Color.lerp(containerWhiteBg, other.containerWhiteBg, t)!,
      greenBg: Color.lerp(greenBg, other.greenBg, t)!, // 추가된 요소
      greenText: Color.lerp(greenText, other.greenText, t)!, // 추가된 요소
    );
  }
}
