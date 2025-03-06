// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_book_category_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccountBookCategoryModelAdapter
    extends TypeAdapter<AccountBookCategoryModel> {
  @override
  final int typeId = 5;

  @override
  AccountBookCategoryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccountBookCategoryModel(
      categoryList: (fields[0] as List)
          .map((dynamic e) => (e as List).cast<AccountBookBtnModel>())
          .toList(),
    );
  }

  @override
  void write(BinaryWriter writer, AccountBookCategoryModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.categoryList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountBookCategoryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountBookCategoryModel _$AccountBookCategoryModelFromJson(
        Map<String, dynamic> json) =>
    AccountBookCategoryModel(
      categoryList: (json['categoryList'] as List<dynamic>)
          .map((e) => (e as List<dynamic>)
              .map((e) =>
                  AccountBookBtnModel.fromJson(e as Map<String, dynamic>))
              .toList())
          .toList(),
    );

Map<String, dynamic> _$AccountBookCategoryModelToJson(
        AccountBookCategoryModel instance) =>
    <String, dynamic>{
      'categoryList': instance.categoryList,
    };
