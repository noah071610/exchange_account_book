import 'package:currency_exchange/common/constant/currency_models.dart';
import 'package:currency_exchange/common/constant/toast.dart';
import 'package:currency_exchange/common/model/currency_card_model.dart';
import 'package:currency_exchange/common/model/currency_model.dart';
import 'package:currency_exchange/common/provider/currency_list_provider.dart';
import 'package:currency_exchange/common/theme/custom_colors.dart';
import 'package:currency_exchange/common/widgets/country_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'dart:async';
import 'package:flutter_slidable/flutter_slidable.dart';

class CurrencySetting extends ConsumerStatefulWidget {
  const CurrencySetting({
    super.key,
  });

  @override
  ConsumerState<CurrencySetting> createState() => _CurrencySettingState();
}

class _CurrencySettingState extends ConsumerState<CurrencySetting> {
  Map<String, List<CurrencyModel>> displayList = continentList;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCurrencyList = ref.watch(currencyListProvider).currencyList;
    final notifier = ref.read(currencyListProvider.notifier);

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
            SliverPersistentHeader(
              pinned: true,
              delegate: SearchBarDelegate(
                controller: _searchController,
                onSearchResult: (results) {
                  setState(() {
                    displayList = results;
                  });
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 30.0,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                color: Color.fromARGB(255, 245, 242, 252),
                child: Text(
                  '선택된 국가',
                  style: TextStyle(
                    color:
                        Theme.of(context).extension<CustomColors>()?.textGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 55.0 * 6 + 8.0 * 6 + 10,
                child: ReorderableListView(
                  physics: NeverScrollableScrollPhysics(), // 스크롤 비활성화
                  onReorder: (int oldIndex, int newIndex) {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    notifier.reorderCurrencyList(oldIndex, newIndex);
                  },
                  children: [
                    for (int index = 0;
                        index < selectedCurrencyList.length;
                        index++)
                      Slidable(
                        key: ValueKey(selectedCurrencyList[index].name),
                        endActionPane: ActionPane(
                          motion: DrawerMotion(),
                          children: [
                            SlidableAction(
                              flex: 1,
                              onPressed: (context) {
                                notifier.removeCurrency(
                                    selectedCurrencyList[index].name, context);
                              },
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              label: context.tr('delete'),
                              // 크기 조정
                            ),
                          ],
                        ),
                        child: Country(
                          key: Key('selected_$index'),
                          entry:
                              currencyModels[selectedCurrencyList[index].name]!,
                          initialIsChecked: true,
                          isSelectedList: true,
                          isPrimaryCountry: index == 0 || index == 1,
                          isLast: index == selectedCurrencyList.length - 1,
                        ),
                      ),
                    if (selectedCurrencyList.length < 5)
                      for (int index = selectedCurrencyList.length;
                          index < 5;
                          index++)
                        Container(
                          key: Key('placeholder_$index'),
                          height: 63.0, // Country 위젯의 높이와 동일하게 설정
                        ),
                  ],
                ),
              ),
            ),
            ...displayList.entries.map(
              (entry) => SliverStickyHeader(
                header: Container(
                  height: 30.0,
                  color: Color.fromARGB(255, 245, 242, 252),
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    context.tr('continent.${entry.key}'),
                    style: TextStyle(
                      color:
                          Theme.of(context).extension<CustomColors>()?.textGrey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => Country(
                      entry: entry.value[i],
                      initialIsChecked: selectedCurrencyList.any(
                          (currency) => currency.name == entry.value[i].name),
                      isLast: i == entry.value.length - 1,
                    ),
                    childCount: entry.value.length,
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

class Country extends ConsumerStatefulWidget {
  final CurrencyModel entry;
  final bool initialIsChecked;
  final bool isSelectedList;
  final bool isLast;
  final bool isPrimaryCountry;

  const Country({
    super.key,
    required this.entry,
    this.initialIsChecked = false,
    this.isSelectedList = false,
    this.isLast = false,
    this.isPrimaryCountry = false,
  });

  @override
  ConsumerState<Country> createState() => _CountryState();
}

class _CountryState extends ConsumerState<Country> {
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
          color: widget.isPrimaryCountry
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

// 🔹 검색 바 Delegate
class SearchBarDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController controller;
  Timer? _debounce;
  final Function(Map<String, List<CurrencyModel>>) onSearchResult;

  SearchBarDelegate({required this.controller, required this.onSearchResult});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10.0),
      color: Color.fromARGB(255, 245, 242, 252),
      child: TextField(
        controller: controller,
        onChanged: (text) {
          if (_debounce?.isActive ?? false) _debounce!.cancel();
          _debounce = Timer(const Duration(seconds: 1), () {
            // 검색어와 일치하는 값을 찾습니다.
            if (text.trim() == '') {
              onSearchResult(continentList);
            } else {
              final Map<String, List<CurrencyModel>> results = Map.fromEntries(
                  continentList.entries
                      .where((entry) => entry.value.any((currency) =>
                          '${context.tr('countries.${currency.countryCode}')}${currency.countryCode}'
                              .toLowerCase()
                              .contains(text.toLowerCase())))
                      .map((entry) => MapEntry(
                          entry.key,
                          entry.value
                              .where((currency) => '${context.tr('countries.${currency.countryCode}')}${currency.countryCode}'.toLowerCase().contains(text.toLowerCase()))
                              .toList()))
                      .where((entry) => entry.value.isNotEmpty));
              // 검색 결과를 처리합니다.

              onSearchResult(results);
            }
          });
        },
        decoration: InputDecoration(
          hintText: context.tr('나라이름, 통화 코드...'),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    controller.clear();
                    onSearchResult(continentList);
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: const Color.fromARGB(200, 255, 255, 255),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 60;
  @override
  double get minExtent => 60;
  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
