// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_card_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CurrencyCardModelAdapter extends TypeAdapter<CurrencyCardModel> {
  @override
  final int typeId = 28;

  @override
  CurrencyCardModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurrencyCardModel(
      name: fields[0] as String,
      amount: fields[1] as double,
    );
  }

  @override
  void write(BinaryWriter writer, CurrencyCardModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.amount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrencyCardModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyCardModel _$CurrencyCardModelFromJson(Map<String, dynamic> json) =>
    CurrencyCardModel(
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
    );

Map<String, dynamic> _$CurrencyCardModelToJson(CurrencyCardModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'amount': instance.amount,
    };
