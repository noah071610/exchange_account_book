import 'package:currency_exchange/common/constant/currency_models.dart';
import 'package:currency_exchange/common/model/currency_model.dart';
import 'package:currency_exchange/common/provider/currency_list_provider.dart';
import 'package:currency_exchange/common/theme/custom_colors.dart';
import 'package:currency_exchange/common/widgets/country_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class CurrencySetting extends ConsumerWidget {
  const CurrencySetting({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final currencyList = ref.watch(currencyListProvider).currencyList;
    return Scaffold(
      body: CustomScrollView(
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
            delegate: SearchBarDelegate(),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 60.0,
              color: Colors.lightBlue,
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              alignment: Alignment.centerLeft,
              child: Text(
                '선택된 국가',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height:
                  80.0 * currencyList.length + 8.0 * currencyList.length + 10,
              child: ReorderableListView(
                physics: NeverScrollableScrollPhysics(), // 스크롤 비활성화
                onReorder: (int oldIndex, int newIndex) {
                  if (newIndex > oldIndex) {
                    newIndex -= 1;
                  }
                  final item = currencyList.removeAt(oldIndex);
                  currencyList.insert(newIndex, item);
                },
                children: [
                  for (int index = 0; index < currencyList.length; index++)
                    Container(
                      key: ValueKey(currencyList[index].name),
                      width: double.infinity, // 100% 너비
                      height: 80,
                      alignment: Alignment.center,
                      margin: EdgeInsets.all(4.0),
                      color: Colors.grey[300],
                      child: Text(currencyList[index].name),
                    ),
                ],
              ),
            ),
          ),
          ...continentList.entries.map(
            (entry) => SliverStickyHeader(
              header: Container(
                height: 60.0,
                color: Colors.lightBlue,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  entry.key,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, i) => Country(
                    entry: entry.value[i],
                    initialIsChecked: currencyList.any(
                        (currency) => currency.name == entry.value[i].name),
                  ),
                  childCount: entry.value.length,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Country extends ConsumerStatefulWidget {
  final CurrencyModel entry;
  final bool initialIsChecked;

  const Country({
    super.key,
    required this.entry,
    this.initialIsChecked = false,
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
    return ListTile(
      leading: CountryImage(
        language: widget.entry.countryCode,
      ),
      title: Text(widget.entry.name),
      trailing: isChecked == true
          ? Icon(Icons.check,
              color: Theme.of(context).extension<CustomColors>()!.primary)
          : null,
    );
  }
}

// 🔹 검색 바 Delegate
class SearchBarDelegate extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10.0),
      color: const Color.fromARGB(255, 245, 242, 252),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search...",
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).extension<CustomColors>()?.divider100,
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
