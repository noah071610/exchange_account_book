import 'package:currency_exchange/common/theme/custom_colors.dart';
import 'package:flutter/material.dart';

class SettingCategoryDetail extends StatelessWidget {
  final Function()? onPressed;
  final String label;
  final bool isEnabled;

  const SettingCategoryDetail({
    Key? key,
    required this.onPressed,
    required this.label,
    this.isEnabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: !isEnabled
            ? Colors.grey[400]
            : Theme.of(context).extension<CustomColors>()?.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextButton(
        onPressed: isEnabled ? onPressed : null,
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 30.0),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 19,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
