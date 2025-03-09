// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_book_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccountBookModelAdapter extends TypeAdapter<AccountBookModel> {
  @override
  final int typeId = 7;

  @override
  AccountBookModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccountBookModel(
      accountType: fields[0] as String,
      subType: fields[1] as String,
      isSpend: fields[4] as bool,
      category: fields[2] as AccountBookBtnModel,
      currency: fields[3] as CurrencyModel,
      createdAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AccountBookModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.accountType)
      ..writeByte(1)
      ..write(obj.subType)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.currency)
      ..writeByte(4)
      ..write(obj.isSpend)
      ..writeByte(5)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountBookModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountBookModel _$AccountBookModelFromJson(Map<String, dynamic> json) =>
    AccountBookModel(
      accountType: json['accountType'] as String,
      subType: json['subType'] as String,
      isSpend: json['isSpend'] as bool,
      category: AccountBookBtnModel.fromJson(
          json['category'] as Map<String, dynamic>),
      currency:
          CurrencyModel.fromJson(json['currency'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$AccountBookModelToJson(AccountBookModel instance) =>
    <String, dynamic>{
      'accountType': instance.accountType,
      'subType': instance.subType,
      'category': instance.category,
      'currency': instance.currency,
      'isSpend': instance.isSpend,
      'createdAt': instance.createdAt.toIso8601String(),
    };
