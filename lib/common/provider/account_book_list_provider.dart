import 'package:currency_exchange/common/hive/account_book_list_hive.dart';
import 'package:currency_exchange/common/model/account_book_list_model.dart';
import 'package:currency_exchange/common/model/account_book_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final accountBookListProvider =
    StateNotifierProvider<AccountBookListNotifier, AccountBookListModel>((ref) {
  return AccountBookListNotifier(ref);
});

class AccountBookListNotifier extends StateNotifier<AccountBookListModel> {
  final Ref _ref;

  AccountBookListNotifier(this._ref)
      : super(AccountBookListModel(accountBookDic: {})) {
    _initializeSetting();
  }

  Future<void> _initializeSetting() async {
    final loaded = await loadAccountBookListFromHive(_ref);
    state = loaded;
  }

  Future<void> addAccountBookList(AccountBookModel model) async {
    final DateFormat yearFormatter = DateFormat('yyyy');
    final DateFormat monthFormatter = DateFormat('MM');
    final DateFormat dayFormatter = DateFormat('dd');

    final String year = yearFormatter.format(model.createdAt);
    final String month = monthFormatter.format(model.createdAt);
    final String day = dayFormatter.format(model.createdAt);

    if (state.accountBookDic[year] == null) {
      state = state.copyWith(
        accountBookDic: {
          ...state.accountBookDic,
          year: {
            month: {
              day: [model]
            }
          }
        },
      );
    } else if (state.accountBookDic[year]![month] == null) {
      state.accountBookDic[year]![month] = {
        day: [model]
      };
      state = state.copyWith(
        accountBookDic: {
          ...state.accountBookDic,
        },
      );
    } else if (state.accountBookDic[year]![month]![day] == null) {
      state.accountBookDic[year]![month]![day] = [model];
      state = state.copyWith(
        accountBookDic: {
          ...state.accountBookDic,
        },
      );
    } else {
      state.accountBookDic[year]![month]![day]!.add(model);
      state = state.copyWith(
        accountBookDic: {
          ...state.accountBookDic,
        },
      );
    }
  }

  Future<void> deleteAccountBookList(
      String year, String month, String day, String id) async {
    if (state.accountBookDic[year] != null &&
        state.accountBookDic[year]![month] != null &&
        state.accountBookDic[year]![month]![day] != null) {
      state.accountBookDic[year]![month]![day]!
          .removeWhere((model) => model.id == id);
      state = state.copyWith(
        accountBookDic: {
          ...state.accountBookDic,
        },
      );
      updateAccountBookListInHive(_ref, state);
    }
  }
}
