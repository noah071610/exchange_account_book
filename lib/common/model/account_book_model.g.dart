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
      id: fields[0] as String,
      accountType: fields[1] as String,
      subType: fields[2] as String,
      category: fields[3] as AccountBookBtnModel,
      currency: fields[4] as CurrencyCardModel,
      targetCurrency: fields[5] as CurrencyCardModel,
      isSpend: fields[6] as bool,
      createdAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AccountBookModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.accountType)
      ..writeByte(2)
      ..write(obj.subType)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.currency)
      ..writeByte(5)
      ..write(obj.targetCurrency)
      ..writeByte(6)
      ..write(obj.isSpend)
      ..writeByte(7)
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
      id: json['id'] as String,
      accountType: json['accountType'] as String,
      subType: json['subType'] as String,
      category: AccountBookBtnModel.fromJson(
          json['category'] as Map<String, dynamic>),
      currency:
          CurrencyCardModel.fromJson(json['currency'] as Map<String, dynamic>),
      targetCurrency: CurrencyCardModel.fromJson(
          json['targetCurrency'] as Map<String, dynamic>),
      isSpend: json['isSpend'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$AccountBookModelToJson(AccountBookModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accountType': instance.accountType,
      'subType': instance.subType,
      'category': instance.category,
      'currency': instance.currency,
      'targetCurrency': instance.targetCurrency,
      'isSpend': instance.isSpend,
      'createdAt': instance.createdAt.toIso8601String(),
    };
