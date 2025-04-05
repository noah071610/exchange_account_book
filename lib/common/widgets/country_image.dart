import 'package:currency_exchange/common/theme/custom_colors.dart';
import 'package:flag/flag.dart';
import 'package:flutter/material.dart';

class CountryImage extends StatelessWidget {
  const CountryImage({
    super.key,
    required this.language,
    this.isSimple = false,
    this.noStyle = false,
  });

  final String language;
  final bool isSimple;
  final bool noStyle;

  @override
  Widget build(BuildContext context) {
    final double paddingValue = isSimple ? 10.0 : 11.0;
    final double borderWidth = 1.0;
    final double flagWidth = isSimple ? 24 : 27;
    final double flagHeight = isSimple ? 15 : 18;

    return noStyle
        ? Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey[200]!,
                width: borderWidth,
              ),
              borderRadius: BorderRadius.circular(1.0),
            ),
            child: Flag.fromString(
              language,
              width: 19,
              height: 13,
              fit: BoxFit.fill,
            ),
          )
        : Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Theme.of(context).extension<CustomColors>()?.primaryBg,
            ),
            child: Padding(
              padding: EdgeInsets.all(paddingValue),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: borderWidth,
                  ),
                  borderRadius: BorderRadius.circular(2.0),
                ),
                child: Flag.fromString(
                  language,
                  width: flagWidth,
                  height: flagHeight,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          );
  }
}
