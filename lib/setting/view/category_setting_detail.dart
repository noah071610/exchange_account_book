import 'package:currency_exchange/common/constant/icon.dart';
import 'package:currency_exchange/common/constant/toast.dart';
import 'package:currency_exchange/common/model/account_book_btn_model.dart';
import 'package:currency_exchange/common/provider/category_list_provider.dart';
import 'package:currency_exchange/common/theme/custom_colors.dart';
import 'package:currency_exchange/setting/widget/setting_category_detail.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class CategorySettingDetail extends ConsumerStatefulWidget {
  final int index;
  final String type;
  final bool isAdd;

  const CategorySettingDetail({
    super.key,
    required this.index,
    required this.type,
    this.isAdd = false,
  });
  @override
  ConsumerState<CategorySettingDetail> createState() =>
      _CategorySettingDetailState();
}

class _CategorySettingDetailState extends ConsumerState<CategorySettingDetail> {
  late String selectedLabel = '';
  late String selectedColor;
  late String selectedIcon;
  late TextEditingController textController;
  late final AccountBookCategoryNotifier _notifier;

  @override
  void initState() {
    super.initState();
    _notifier = ref.read(accountBookCategoryProvider.notifier);

    if (!widget.isAdd && widget.index > -1) {
      final provider = ref.read(accountBookCategoryProvider);
      final categories = widget.type == 'income'
          ? provider.incomeCategories
          : provider.spendCategories;
      final target = categories[widget.index];

      selectedLabel = target.label;
      selectedColor = target.color;
      selectedIcon = target.icon;
      textController = TextEditingController(text: target.label);
    } else {
      selectedLabel = '';
      selectedColor = '#BDBDBD';
      selectedIcon = 'plusCircle';
      textController = TextEditingController(text: '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${selectedLabel.contains('category.') ? context.tr(selectedLabel) : selectedLabel} ${context.tr('settings.settings')}'),
      ),
      body: Container(
        color: Theme.of(context).extension<CustomColors>()?.containerWhiteBg,
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: 5.0),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: 20,
                      children: [
                        // 첫 번째 열 (100px 고정)
                        SizedBox(
                          width: 100,
                          child: Column(
                            children: [
                              Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  color: Color(int.parse(
                                      selectedColor.replaceFirst('#', '0xff'))),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  iconDictionary[selectedIcon],
                                  color: Colors.white,
                                  size: 50.0,
                                ),
                              ),
                              Text(
                                selectedLabel.isEmpty
                                    ? context.tr('category_setting.empty_label')
                                    : selectedLabel.contains('category.')
                                        ? context.tr(selectedLabel)
                                        : selectedLabel,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // 두 번째 열 (나머지 공간 전체)
                        Column(
                          children: [
                            SettingCategoryDetail(
                              label:
                                  context.tr('category_setting.change_color'),
                              onPressed: () {
                                Color pickerColor = Color(int.parse(
                                    selectedColor.replaceFirst('#', '0xff')));

                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: Text(
                                        context.tr(
                                            'category_setting.change_color'),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold)),
                                    content: SingleChildScrollView(
                                      child: ColorPicker(
                                        pickerColor: pickerColor,
                                        onColorChanged: (Color color) {
                                          pickerColor = color;
                                        },
                                        pickerAreaHeightPercent: 0.8,
                                        enableAlpha: false,
                                        labelTypes: [], // 라벨 숨기기
                                        displayThumbColor: true,
                                        paletteType: PaletteType.hsvWithHue,
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text(context
                                            .tr('category_setting.cancel')),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: Text(context
                                            .tr('category_setting.select')),
                                        onPressed: () {
                                          setState(() {
                                            selectedColor =
                                                '#${pickerColor.value.toRadixString(16).substring(2)}';
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 10),
                            SettingCategoryDetail(
                              label: context.tr('category_setting.change_icon'),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: Text(
                                        context
                                            .tr('category_setting.change_icon'),
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold)),
                                    content: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: SingleChildScrollView(
                                        child: GridView.count(
                                          crossAxisCount: 6,
                                          crossAxisSpacing: 3,
                                          mainAxisSpacing: 3,
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          children: [
                                            for (var icon in iconKeys)
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedIcon = icon;
                                                    Navigator.of(context).pop();
                                                  });
                                                },
                                                child: Opacity(
                                                  opacity: selectedIcon == icon
                                                      ? 1.0
                                                      : 0.4,
                                                  child: Icon(
                                                    iconDictionary[icon],
                                                    size: 30,
                                                    color: selectedIcon == icon
                                                        ? Theme.of(context)
                                                            .extension<
                                                                CustomColors>()
                                                            ?.primary
                                                        : Theme.of(context)
                                                            .extension<
                                                                CustomColors>()
                                                            ?.opposite,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text(context
                                            .tr('category_setting.cancel')),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 10),
                            SettingCategoryDetail(
                              label:
                                  context.tr('category_setting.change_label'),
                              isEnabled: !selectedLabel.contains('category.'),
                              onPressed: !selectedLabel.contains('category.')
                                  ? () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          title: Text(
                                              context.tr(
                                                  'category_setting.change_label'),
                                              style: TextStyle(
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold)),
                                          content: TextField(
                                            controller: textController,
                                            onChanged: (text) {
                                              if (text.characters.length > 7) {
                                                textController.text = text
                                                    .characters
                                                    .take(7)
                                                    .toString();
                                              }
                                            },
                                            decoration: InputDecoration(
                                              hintText: context.tr(
                                                  'category_setting.new_label'),
                                              border: OutlineInputBorder(),
                                              enabled: !selectedLabel
                                                  .contains('category.'),
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text(context.tr(
                                                  'category_setting.cancel')),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              onPressed: !selectedLabel
                                                      .contains('category.')
                                                  ? () {
                                                      setState(() {
                                                        selectedLabel =
                                                            textController.text;
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                  : null,
                                              child: Text(context.tr(
                                                  'category_setting.select')),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 30, 161, 69),
                    const Color.fromARGB(255, 91, 187, 120),
                    const Color.fromARGB(255, 88, 183, 116),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextButton(
                onPressed: () {
                  if (!widget.isAdd && widget.index > -1) {
                    if (widget.type == 'income') {
                      _notifier.updateIncomeCategory(
                        widget.index,
                        AccountBookBtnModel(
                          label: selectedLabel,
                          icon: selectedIcon,
                          color: selectedColor,
                        ),
                      );
                    } else {
                      _notifier.updateSpendCategory(
                        widget.index,
                        AccountBookBtnModel(
                          label: selectedLabel,
                          icon: selectedIcon,
                          color: selectedColor,
                        ),
                      );
                    }
                    showCustomToast(
                        context: context,
                        message: context.tr('category_setting.save_category'));
                  } else {
                    if (selectedLabel.isEmpty) {
                      return showCustomToast(
                          context: context,
                          message: context.tr('category_setting.need_label'));
                    }
                    if (widget.type == 'income') {
                      _notifier.addIncomeCategory(
                        AccountBookBtnModel(
                          label: selectedLabel,
                          icon: selectedIcon,
                          color: selectedColor,
                        ),
                      );
                    } else {
                      _notifier.addSpendCategory(
                        AccountBookBtnModel(
                          label: selectedLabel,
                          icon: selectedIcon,
                          color: selectedColor,
                        ),
                      );
                    }
                    showCustomToast(
                        context: context,
                        message: context.tr('category_setting.add_category'));
                  }
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  padding:
                      EdgeInsets.symmetric(vertical: 17.0, horizontal: 30.0),
                ),
                child: Text(
                  context.tr('category_setting.save_category'),
                  style: TextStyle(
                    fontSize: 19,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (!widget.isAdd)
              SizedBox(
                child: TextButton(
                  onPressed: () {
                    if (widget.type == 'income') {
                      _notifier.removeIncomeCategory(
                        widget.index,
                      );
                    } else {
                      _notifier.removeSpendCategory(
                        widget.index,
                      );
                    }
                    showCustomToast(
                        context: context,
                        message:
                            context.tr('category_setting.remove_category'));
                    Navigator.pop(context);
                  },
                  child: Text(
                    context.tr('category_setting.delete_category'),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
