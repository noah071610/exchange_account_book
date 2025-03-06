// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CurrencyModelAdapter extends TypeAdapter<CurrencyModel> {
  @override
  final int typeId = 3;

  @override
  CurrencyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurrencyModel(
      countryCode: fields[0] as String,
      inputAmount: fields[1] as double,
      displayAmount: fields[2] as double,
      index: fields[3] as int,
      quickTag: (fields[4] as List).cast<int>(),
    );
  }

  @override
  void write(BinaryWriter writer, CurrencyModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.countryCode)
      ..writeByte(1)
      ..write(obj.inputAmount)
      ..writeByte(2)
      ..write(obj.displayAmount)
      ..writeByte(3)
      ..write(obj.index)
      ..writeByte(4)
      ..write(obj.quickTag);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrencyModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyModel _$CurrencyModelFromJson(Map<String, dynamic> json) =>
    CurrencyModel(
      countryCode: json['countryCode'] as String,
      inputAmount: (json['inputAmount'] as num).toDouble(),
      displayAmount: (json['displayAmount'] as num).toDouble(),
      index: (json['index'] as num).toInt(),
      quickTag: (json['quickTag'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$CurrencyModelToJson(CurrencyModel instance) =>
    <String, dynamic>{
      'countryCode': instance.countryCode,
      'inputAmount': instance.inputAmount,
      'displayAmount': instance.displayAmount,
      'index': instance.index,
      'quickTag': instance.quickTag,
    };
