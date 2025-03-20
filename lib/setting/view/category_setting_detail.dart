import 'package:currency_exchange/common/constant/color.dart';
import 'package:currency_exchange/common/constant/currency_models.dart';
import 'package:currency_exchange/common/constant/icon.dart';
import 'package:currency_exchange/common/constant/toast.dart';
import 'package:currency_exchange/common/model/currency_card_model.dart';
import 'package:currency_exchange/common/model/currency_model.dart';
import 'package:currency_exchange/common/provider/category_list_provider.dart';
import 'package:currency_exchange/common/provider/currency_list_provider.dart';
import 'package:currency_exchange/common/theme/custom_colors.dart';
import 'package:currency_exchange/common/widgets/account_book_setting_card.dart';
import 'package:currency_exchange/common/widgets/country_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';

class CategorySettingDetail extends ConsumerWidget {
  final int index;
  final String type;

  const CategorySettingDetail({
    super.key,
    required this.index,
    required this.type,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(accountBookCategoryProvider);
    final notifier = ref.read(accountBookCategoryProvider.notifier);
    final categories =
        type == 'income' ? provider.incomeCategories : provider.spendCategories;
    final target = categories[index];

    String selectedLabel = target.label;
    String selectedColor = target.color;
    String selectedIcon = target.icon;

    return Scaffold(
      appBar: AppBar(
        title: Text('${target.label} 설정'),
      ),
      body: Container(
        color: Theme.of(context).extension<CustomColors>()?.containerWhiteBg,
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 라벨 변경
              Text('라벨 변경', style: TextStyle(fontWeight: FontWeight.bold)),
              TextField(
                controller: TextEditingController(text: selectedLabel),
                onChanged: (value) {
                  selectedLabel = value;
                },
                decoration: InputDecoration(
                  hintText: '새로운 라벨 입력',
                ),
              ),
              SizedBox(height: 20),

              // 색상 변경
              Text('색상 변경', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 7),
              GridView.count(
                crossAxisCount: 8,
                crossAxisSpacing: 3,
                mainAxisSpacing: 3,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  for (var color in categoryColors)
                    GestureDetector(
                      onTap: () {
                        selectedColor = color;
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color:
                              Color(int.parse(color.replaceFirst('#', '0xff'))),
                          borderRadius: BorderRadius.circular(10),
                          border: selectedColor == color
                              ? Border.all(color: Colors.purple, width: 2)
                              : null,
                        ),
                      ),
                    ),
                ],
              ),

              // 아이콘 변경
              Text('아이콘 변경', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 7),
              Container(
                child: GridView.count(
                  crossAxisCount: 8,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 3,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    for (var icon in iconKeys)
                      GestureDetector(
                        onTap: () {
                          selectedIcon = icon;
                        },
                        child: Opacity(
                          opacity: selectedIcon == icon ? 1.0 : 0.4,
                          child: Icon(
                            iconDictionary[icon],
                            size: 30,
                            color: selectedIcon == icon
                                ? Theme.of(context)
                                    .extension<CustomColors>()
                                    ?.primary
                                : Theme.of(context)
                                    .extension<CustomColors>()
                                    ?.opposite,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // 변경하기 버튼
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // 변경 사항 적용 로직
                    // 예: notifier.updateCategory(index, selectedLabel, selectedColor, selectedIcon);
                  },
                  child: Text('변경하기'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
