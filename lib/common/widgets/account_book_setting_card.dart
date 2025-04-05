import 'package:currency_exchange/common/constant/icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AccountBookSettingCard extends ConsumerWidget {
  final String icon;
  final String label;
  final String color;
  final String type;
  final int? index;

  const AccountBookSettingCard({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.type,
    this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min, // mainAxisSize를 MainAxisSize.min으로 설정
      children: [
        Flexible(
          // Expanded 대신 Flexible 사용
          fit: FlexFit.loose, // FlexFit.loose로 설정
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Container(
                width: constraints.maxWidth, // 최대 너비 설정
                height: constraints.maxWidth, // 최대 높이 설정
                decoration: BoxDecoration(
                  color: Color(int.parse(color.replaceFirst('#', '0xff'))),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: Icon(iconDictionary[icon], size: 18.0),
                  onPressed: () {
                    if (index != null) {
                      context.go('/category-setting/$type/$index');
                    }
                  },
                  color: Colors.white,
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 3,
        ),
        Text(
          label.contains('category.') ? context.tr(label) : label,
          style: TextStyle(
            fontSize: 12,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }
}
