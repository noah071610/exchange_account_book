import 'package:currency_exchange/common/constant/currency_models.dart';
import 'package:currency_exchange/common/model/currency_card_model.dart';
import 'package:currency_exchange/common/model/currency_model.dart';
import 'package:currency_exchange/common/theme/custom_colors.dart';
import 'package:currency_exchange/common/utils/utils.dart';
import 'package:currency_exchange/common/widgets/calculator_sheet.dart';
import 'package:currency_exchange/common/widgets/country_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CurrencyCard extends ConsumerWidget {
  final CurrencyCardModel cardBaseData;
  final CurrencyCardModel cardTargetData;
  final bool isSimple;

  CurrencyCard({
    super.key,
    this.isSimple = false,
    required this.cardBaseData,
    required this.cardTargetData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CurrencyModel baseData = currencyModels[cardBaseData.name]!;
    final CurrencyModel targetData = currencyModels[cardTargetData.name]!;

    return GestureDetector(
      onTap: isSimple
          ? () {}
          : () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return CalculatorSheet(
                    baseData: baseData,
                    targetData: targetData,
                  );
                },
              );
            },
      child: Container(
        padding: EdgeInsets.only(top: 12, bottom: 12, left: 10, right: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).extension<CustomColors>()!.containerBg,
        ),
        child: Row(
          mainAxisAlignment: isSimple
              ? MainAxisAlignment.start
              : MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              spacing: 3.0,
              children: [
                CountryImage(
                  language: baseData.countryCode,
                  isSimple: isSimple,
                ),
                if (!isSimple)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 0,
                    children: [
                      Text(
                        context.tr('countries.${baseData.countryCode}'),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 1.0,
                        ),
                      ),
                      Text(
                        baseData.currencyCode,
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
            if (isSimple)
              SizedBox(
                width: 3,
              ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:
                  isSimple ? CrossAxisAlignment.start : CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: isSimple ? 8 : 12.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(isSimple ? 4.0 : 8.0),
                    color: Theme.of(context).extension<CustomColors>()?.greenBg,
                  ),
                  child: Text(
                    '${baseData.currencySymbol} ${formatDouble(cardBaseData.amount)}',
                    style: TextStyle(
                      fontSize: isSimple ? 12 : 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context)
                          .extension<CustomColors>()
                          ?.greenText,
                      height: 1.2,
                    ),
                  ),
                  // textAlign: TextAlign.right,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 2.5),
                  child: Text(
                    convertToKoreanNumber(
                        cardBaseData.amount, context, baseData.countryCode),
                    style: TextStyle(
                      fontSize: isSimple ? 11 : 13,
                      fontWeight: FontWeight.w500,
                      color:
                          Theme.of(context).extension<CustomColors>()?.textGrey,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
