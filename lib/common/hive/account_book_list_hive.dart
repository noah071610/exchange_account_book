import 'package:currency_exchange/common/model/account_book_list_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:currency_exchange/common/hive/hive.dart';

final key = 'account_book';

Future<AccountBookListModel> loadAccountBookListFromHive(
    Ref<Object?> ref) async {
  final box = await ref.read(boxProvider(key).future);
  final AccountBookListModel list =
      box.get(key, defaultValue: AccountBookListModel(accountBookDic: {}));

  return list;
}

Future<void> updateAccountBookListInHive(
    Ref<Object?> ref, AccountBookListModel state) async {
  final box = await ref.read(boxProvider(key).future);
  await box.put(key, state);
}
