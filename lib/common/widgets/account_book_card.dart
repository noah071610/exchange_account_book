import 'package:currency_exchange/common/constant/icon.dart';
import 'package:currency_exchange/common/model/account_book_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AccountBookCard extends StatelessWidget {
  final AccountBookModel model;
  final bool isActive;
  final void Function(AccountBookModel) onTap;

  const AccountBookCard({
    super.key,
    required this.model,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 15.0,
            children: [
              Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Color(int.parse(
                          model.category.color.replaceFirst('#', '0xff'))),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(iconDictionary[model.category.icon]),
                      onPressed: () {
                        onTap(model);
                      },
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                spacing: 2.0,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: const Color.fromARGB(255, 191, 245, 190),
                    ),
                    child: Text(
                      context.tr('category.${model.consumptionType}'),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 24, 118, 28),
                        height: 1.2,
                      ),
                    ),
                    // textAlign: TextAlign.right,
                  ),
                  Text(
                    context.tr('category.${model.category.label}'),
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  )
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    model.isSpend ? '-' : '+',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: model.isSpend ? Colors.redAccent : Colors.green,
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    model.baseCurrency.currencyCode,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: model.isSpend ? Colors.redAccent : Colors.green,
                    ),
                  ),
                  SizedBox(
                    width: 1,
                  ),
                  Text(
                    model.baseCurrency.amount.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: model.isSpend ? Colors.redAccent : Colors.green,
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    model.targetCurrency.currencyCode,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    model.targetCurrency.amount.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
