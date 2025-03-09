import 'package:currency_exchange/common/model/account_book_btn_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AccountBookTag extends StatelessWidget {
  final AccountBookBtnModel model;
  final bool isActive;
  final void Function(String) onTap;

  const AccountBookTag({
    super.key,
    required this.model,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(model.label);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isActive
              ? Colors.purple
              : const Color.fromARGB(255, 228, 228, 228),
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        child: Text(
          context.tr('category.${model.label}'),
          style: TextStyle(
            fontSize: 14,
            color: isActive ? Colors.white : Colors.black45,
          ),
        ),
      ),
    );
  }
}
