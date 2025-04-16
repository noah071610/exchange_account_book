import 'package:currency_exchange/common/constant/currency_models.dart';
import 'package:currency_exchange/common/model/account_book_btn_model.dart';
import 'package:currency_exchange/common/model/currency_model.dart';
import 'package:currency_exchange/common/provider/category_list_provider.dart';
import 'package:currency_exchange/common/theme/custom_colors.dart';
import 'package:currency_exchange/common/widgets/account_book_setting_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_reorderable_grid_view/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

class CategorySetting extends ConsumerStatefulWidget {
  const CategorySetting({
    super.key,
  });

  @override
  ConsumerState<CategorySetting> createState() => _CategorySettingState();
}

class _CategorySettingState extends ConsumerState<CategorySetting> {
  Map<String, List<CurrencyModel>> displayList = continentList;
  final _scrollControllerSpend = ScrollController();
  final _scrollControllerIncome = ScrollController();
  final _gridViewKeySpend = GlobalKey();
  final _gridViewKeyIncome = GlobalKey();

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
            SliverAppBar(
              backgroundColor: Color.fromARGB(255, 245, 242, 252),
              surfaceTintColor: Color.fromARGB(255, 245, 242, 252),
              pinned: true, // 스크롤 시 AppBar 고정
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  context.tr('settings.category_settings'),
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
                  context.tr('category_setting.spend_category'),
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
                padding: const EdgeInsets.all(16.0),
                child: ReorderableBuilder(
                  scrollController: _scrollControllerSpend,
                  onReorder: (ReorderedListFunction reorderedListFunction) {
                    notifier.reorderSpendCategories(
                      reorderedListFunction(spendCategories)
                          as List<AccountBookBtnModel>,
                    );
                  },
                  builder: (children) {
                    return GridView(
                      key: _gridViewKeySpend,
                      controller: _scrollControllerSpend,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 2.0, // 간격을 좁히기 위해 crossAxisSpacing 추가
                      ),
                      padding: EdgeInsets.zero, // 패딩을 제거하여 간격을 좁힘
                      children: children,
                    );
                  },
                  children: [
                    ...spendCategories.asMap().entries.map(
                          (entry) => AccountBookSettingCard(
                            key: ValueKey(
                                'spend_${entry.value.label}_${entry.value.color}'),
                            index: entry.key,
                            color: entry.value.color,
                            icon: entry.value.icon,
                            label: entry.value.label,
                            type: 'spend',
                          ),
                        ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      context.go('/category-setting/spend/add');
                    },
                    child: Text(context.tr('category_setting.add_category')),
                  ),
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
                  context.tr('category_setting.income_category'),
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
                padding: const EdgeInsets.all(16.0),
                child: ReorderableBuilder(
                  scrollController: _scrollControllerIncome,
                  onReorder: (ReorderedListFunction reorderedListFunction) {
                    notifier.reorderIncomeCategories(
                      reorderedListFunction(incomeCategories)
                          as List<AccountBookBtnModel>,
                    );
                  },
                  builder: (children) {
                    return GridView(
                      key: _gridViewKeyIncome,
                      controller: _scrollControllerIncome,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 6,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 2.0, // 간격을 좁히기 위해 crossAxisSpacing 추가
                      ),
                      padding: EdgeInsets.zero, // 패딩을 제거하여 간격을 좁힘
                      children: children,
                    );
                  },
                  children: [
                    ...incomeCategories.asMap().entries.map(
                          (entry) => AccountBookSettingCard(
                            key: ValueKey(
                                'income_${entry.value.label}_${entry.value.color}'),
                            index: entry.key,
                            color: entry.value.color,
                            icon: entry.value.icon,
                            label: entry.value.label,
                            type: 'income',
                          ),
                        ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: () {
                      context.go('/category-setting/income/add');
                    },
                    child: Text(context.tr('category_setting.add_category')),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
