// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_pair_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CurrencyPairModelAdapter extends TypeAdapter<CurrencyPairModel> {
  @override
  final int typeId = 2;

  @override
  CurrencyPairModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurrencyPairModel(
      baseCurrency: fields[0] as CurrencyModel,
      targetCurrency: fields[1] as CurrencyModel,
    );
  }

  @override
  void write(BinaryWriter writer, CurrencyPairModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.baseCurrency)
      ..writeByte(1)
      ..write(obj.targetCurrency);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrencyPairModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyPairModel _$CurrencyPairModelFromJson(Map<String, dynamic> json) =>
    CurrencyPairModel(
      baseCurrency:
          CurrencyModel.fromJson(json['baseCurrency'] as Map<String, dynamic>),
      targetCurrency: CurrencyModel.fromJson(
          json['targetCurrency'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CurrencyPairModelToJson(CurrencyPairModel instance) =>
    <String, dynamic>{
      'baseCurrency': instance.baseCurrency,
      'targetCurrency': instance.targetCurrency,
    };
