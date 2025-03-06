// COMP: MASKING
import 'package:flutter/material.dart';
import 'package:currency_exchange/common/utils/utils.dart';

class HiddenTextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final double height;

  const HiddenTextWidget({
    Key? key,
    required this.text,
    required this.fontSize,
    required this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: height,
          width: getTextSize(
            context,
            text,
            TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
          ).width,
          decoration: BoxDecoration(
            color: Colors.grey[400],
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(height: 5),
      ],
    );
  }
}
