// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_book_list_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccountBookListModelAdapter extends TypeAdapter<AccountBookListModel> {
  @override
  final int typeId = 8;

  @override
  AccountBookListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccountBookListModel(
      accountBookDic: (fields[0] as Map).map((dynamic k, dynamic v) => MapEntry(
          k as String,
          (v as Map).map((dynamic k, dynamic v) => MapEntry(
              k as String,
              (v as Map).map((dynamic k, dynamic v) => MapEntry(
                  k as String, (v as List).cast<AccountBookModel>())))))),
    );
  }

  @override
  void write(BinaryWriter writer, AccountBookListModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.accountBookDic);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountBookListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountBookListModel _$AccountBookListModelFromJson(
        Map<String, dynamic> json) =>
    AccountBookListModel(
      accountBookDic: (json['accountBookDic'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k,
            (e as Map<String, dynamic>).map(
              (k, e) => MapEntry(
                  k,
                  (e as Map<String, dynamic>).map(
                    (k, e) => MapEntry(
                        k,
                        (e as List<dynamic>)
                            .map((e) => AccountBookModel.fromJson(
                                e as Map<String, dynamic>))
                            .toList()),
                  )),
            )),
      ),
    );

Map<String, dynamic> _$AccountBookListModelToJson(
        AccountBookListModel instance) =>
    <String, dynamic>{
      'accountBookDic': instance.accountBookDic,
    };
