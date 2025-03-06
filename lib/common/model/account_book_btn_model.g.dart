// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_book_btn_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccountBookBtnModelAdapter extends TypeAdapter<AccountBookBtnModel> {
  @override
  final int typeId = 6;

  @override
  AccountBookBtnModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AccountBookBtnModel(
      label: fields[0] as String,
      icon: fields[1] as String,
      color: fields[2] as String,
      favorite: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AccountBookBtnModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.label)
      ..writeByte(1)
      ..write(obj.icon)
      ..writeByte(2)
      ..write(obj.color)
      ..writeByte(3)
      ..write(obj.favorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountBookBtnModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountBookBtnModel _$AccountBookBtnModelFromJson(Map<String, dynamic> json) =>
    AccountBookBtnModel(
      label: json['label'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
      favorite: json['favorite'] as bool,
    );

Map<String, dynamic> _$AccountBookBtnModelToJson(
        AccountBookBtnModel instance) =>
    <String, dynamic>{
      'label': instance.label,
      'icon': instance.icon,
      'color': instance.color,
      'favorite': instance.favorite,
    };
