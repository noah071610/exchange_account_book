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
      category: fields[0] as AccountBookBtnModel,
      consumptionType: fields[1] as String,
      isSpend: fields[2] as bool,
      baseCurrency: fields[3] as CurrencyModel,
      targetCurrency: fields[4] as CurrencyModel,
      createdAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, AccountBookModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.category)
      ..writeByte(1)
      ..write(obj.consumptionType)
      ..writeByte(2)
      ..write(obj.isSpend)
      ..writeByte(3)
      ..write(obj.baseCurrency)
      ..writeByte(4)
      ..write(obj.targetCurrency)
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
      category: AccountBookBtnModel.fromJson(
          json['category'] as Map<String, dynamic>),
      consumptionType: json['consumptionType'] as String,
      isSpend: json['isSpend'] as bool,
      baseCurrency:
          CurrencyModel.fromJson(json['baseCurrency'] as Map<String, dynamic>),
      targetCurrency: CurrencyModel.fromJson(
          json['targetCurrency'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$AccountBookModelToJson(AccountBookModel instance) =>
    <String, dynamic>{
      'category': instance.category,
      'consumptionType': instance.consumptionType,
      'isSpend': instance.isSpend,
      'baseCurrency': instance.baseCurrency,
      'targetCurrency': instance.targetCurrency,
      'createdAt': instance.createdAt.toIso8601String(),
    };
