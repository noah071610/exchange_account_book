import 'package:currency_exchange/common/constant/currency_models.dart';
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

class CategorySetting extends ConsumerStatefulWidget {
  const CategorySetting({
    super.key,
  });

  @override
  ConsumerState<CategorySetting> createState() => _CategorySettingState();
}

class _CategorySettingState extends ConsumerState<CategorySetting> {
  Map<String, List<CurrencyModel>> displayList = continentList;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spendCategories =
        ref.watch(accountBookCategoryProvider).spendCategories;
    final incomeCategories =
        ref.watch(accountBookCategoryProvider).incomeCategories;
    final notifier = ref.read(accountBookCategoryProvider.notifier);

    return Scaffold(
      body: Container(
        color: Theme.of(context).extension<CustomColors>()?.containerWhiteBg,
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
              backgroundColor: Color.fromARGB(255, 245, 242, 252),
              surfaceTintColor: Color.fromARGB(255, 245, 242, 252),
              pinned: true, // 스크롤 시 AppBar 고정
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  "Search Bar Example",
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 30.0,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                color: Color.fromARGB(255, 245, 242, 252),
                child: Text(
                  '지출 카테고리',
                  style: TextStyle(
                    color:
                        Theme.of(context).extension<CustomColors>()?.textGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Wrap(
                  spacing: 13.0,
                  runSpacing: 8.0,
                  children: spendCategories
                      .asMap()
                      .entries
                      .map(
                        (entry) => AccountBookSettingCard(
                          index: entry.key,
                          model: entry.value,
                          type: 'spend',
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 30.0,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                color: Color.fromARGB(255, 245, 242, 252),
                child: Text(
                  '수입 카테고리',
                  style: TextStyle(
                    color:
                        Theme.of(context).extension<CustomColors>()?.textGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Wrap(
                  spacing: 13.0,
                  runSpacing: 8.0,
                  children: incomeCategories
                      .asMap()
                      .entries
                      .map(
                        (entry) => AccountBookSettingCard(
                          index: entry.key,
                          model: entry.value,
                          type: 'income',
                          // onTap: (int index) {
                          //   // 여기
                          // },
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Category extends ConsumerStatefulWidget {
  final CurrencyModel entry;
  final bool initialIsChecked;
  final bool isSelectedList;
  final bool isLast;
  final bool isPrimaryCategory;

  const Category({
    super.key,
    required this.entry,
    this.initialIsChecked = false,
    this.isSelectedList = false,
    this.isLast = false,
    this.isPrimaryCategory = false,
  });

  @override
  ConsumerState<Category> createState() => _CategoryState();
}

class _CategoryState extends ConsumerState<Category> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    isChecked = widget.initialIsChecked;
  }

  @override
  Widget build(BuildContext context) {
    final selectedCurrencyList = ref.watch(currencyListProvider).currencyList;
    final notifier = ref.read(currencyListProvider.notifier);
    return GestureDetector(
      onTap: () {
        if (widget.isSelectedList) {
          return;
        } else {
          if (isChecked) {
            if (selectedCurrencyList.length <= 2) {
              // 리스트가 2개 이하일 때는 삭제 불가
              showCustomToast(
                  context: context,
                  message: context.tr('at_least_two_currency'));
              return;
            }
            notifier.removeCurrency(widget.entry.name, context);
            isChecked = false;
          } else {
            if (selectedCurrencyList.length >= 6) {
              // 리스트가 5개 이상일 때는 추가 불가
              showCustomToast(
                  context: context, message: context.tr('maximum_five'));
              return;
            }
            notifier.addCurrency(
                CurrencyCardModel(name: widget.entry.name, amount: 0.0),
                context);
            isChecked = true;
          }
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: widget.isPrimaryCategory
              ? const Color.fromARGB(141, 217, 252, 217)
              // ? Theme.of(context).extension<CustomColors>()?.greenBg
              : null,
          border: widget.isLast
              ? null
              : Border(
                  bottom: BorderSide(
                    color:
                        Theme.of(context).extension<CustomColors>()!.divider100,
                    width: 1.0,
                  ),
                ),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
          leading: CountryImage(
            language: widget.entry.countryCode,
          ),
          title: Text(context.tr('countries.${widget.entry.countryCode}')),
          trailing: widget.isSelectedList
              ? Icon(
                  Icons.drag_handle,
                  color: Theme.of(context).extension<CustomColors>()?.icon,
                )
              : isChecked == true
                  ? Icon(Icons.check,
                      color:
                          Theme.of(context).extension<CustomColors>()!.primary)
                  : null,
        ),
      ),
    );
  }
}
