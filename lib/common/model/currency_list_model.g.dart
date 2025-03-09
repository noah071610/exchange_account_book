// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_list_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CurrencyListModelAdapter extends TypeAdapter<CurrencyListModel> {
  @override
  final int typeId = 1;

  @override
  CurrencyListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CurrencyListModel(
      currencyList: (fields[0] as List).cast<CurrencyModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, CurrencyListModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.currencyList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrencyListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyListModel _$CurrencyListModelFromJson(Map<String, dynamic> json) =>
    CurrencyListModel(
      currencyList: (json['currencyList'] as List<dynamic>)
          .map((e) => CurrencyModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CurrencyListModelToJson(CurrencyListModel instance) =>
    <String, dynamic>{
      'currencyList': instance.currencyList,
    };
