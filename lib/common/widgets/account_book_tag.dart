import 'package:currency_exchange/common/theme/custom_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AccountBookTag extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isNotMainCategory;
  final void Function(String) onTap;

  const AccountBookTag({
    super.key,
    required this.label,
    required this.onTap,
    this.isNotMainCategory = false,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(label);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isActive
              ? const Color.fromARGB(255, 56, 165, 88)
              : Theme.of(context).extension<CustomColors>()?.divider100,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        child: Text(
          isNotMainCategory
              ? context.tr('category.$label')
              : label.contains('category.')
                  ? context.tr(label)
                  : label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.white : Colors.black45,
          ),
        ),
      ),
    );
  }
}
