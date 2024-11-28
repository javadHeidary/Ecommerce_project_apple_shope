// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basket_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BasketItemModelAdapter extends TypeAdapter<BasketItemModel> {
  @override
  final int typeId = 0;

  @override
  BasketItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BasketItemModel(
      fields[0] as String?,
      fields[1] as String?,
      fields[2] as String?,
      fields[3] as int,
      fields[4] as int,
      fields[5] as String?,
      fields[6] as String?,
    )
      ..realPrice = fields[7] as int?
      ..percent = fields[8] as num?;
  }

  @override
  void write(BinaryWriter writer, BasketItemModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.collectionId)
      ..writeByte(2)
      ..write(obj.thumbnail)
      ..writeByte(3)
      ..write(obj.discountPrice)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.name)
      ..writeByte(6)
      ..write(obj.categoryId)
      ..writeByte(7)
      ..write(obj.realPrice)
      ..writeByte(8)
      ..write(obj.percent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BasketItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
