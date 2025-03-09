import 'package:currency_exchange/common/constant/icon.dart';
import 'package:currency_exchange/common/model/account_book_model.dart';
import 'package:currency_exchange/common/model/currency_model.dart';
import 'package:currency_exchange/common/widgets/country_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AccountTotalByDay extends StatelessWidget {
  final Map<String, dynamic> model;

  const AccountTotalByDay({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final CurrencyModel currency = model['currency'];
    final bool isTotalPositive =
        (model['incomeSum'] - model['spendSum']) >= 0.0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 3.0,
            children: [
              CountryImage(language: currency.countryCode),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 0,
                children: [
                  Text(
                    context.tr('countries.${currency.countryCode}'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),
                  Text(
                    currency.currencyCode,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.2,
                    ),
                  ),
                ],
              )
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    currency.currencySymbol,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    model['incomeSum'].toString(),
                    style: TextStyle(
                      fontSize: 21,
                      color: Colors.green,
                      height: 1.0,
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '-',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.redAccent,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    currency.currencySymbol,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.redAccent,
                    ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    model['spendSum'].toString(),
                    style: TextStyle(
                      fontSize: 21,
                      color: Colors.redAccent,
                      height: 1.0,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: const Color.fromARGB(255, 234, 190, 245),
                    ),
                    child: Text(
                      '총합',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color.fromARGB(255, 74, 24, 118),
                        height: 1.2,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    isTotalPositive ? '+' : '-',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isTotalPositive ? Colors.green : Colors.redAccent,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    currency.currencySymbol,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isTotalPositive ? Colors.green : Colors.redAccent,
                    ),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Text(
                    (model['incomeSum'] - model['spendSum']).abs().toString(),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: isTotalPositive ? Colors.green : Colors.redAccent,
                      height: 1.1,
                    ),
                  )
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
