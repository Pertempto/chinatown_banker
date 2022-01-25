// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BusinessAdapter extends TypeAdapter<Business> {
  @override
  final int typeId = 5;

  @override
  Business read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Business(
      fields[0] as String,
      fields[1] as ShopType,
      fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Business obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.shopType)
      ..writeByte(2)
      ..write(obj.size);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BusinessAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ShopTypeAdapter extends TypeAdapter<ShopType> {
  @override
  final int typeId = 6;

  @override
  ShopType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ShopType.photo;
      case 1:
        return ShopType.teaHouse;
      case 2:
        return ShopType.seaFood;
      case 3:
        return ShopType.jewellery;
      case 4:
        return ShopType.tropicalFish;
      case 5:
        return ShopType.florist;
      case 6:
        return ShopType.takeOut;
      case 7:
        return ShopType.laundry;
      case 8:
        return ShopType.dimSum;
      case 9:
        return ShopType.antiques;
      case 10:
        return ShopType.factory;
      case 11:
        return ShopType.restaurant;
      default:
        return ShopType.photo;
    }
  }

  @override
  void write(BinaryWriter writer, ShopType obj) {
    switch (obj) {
      case ShopType.photo:
        writer.writeByte(0);
        break;
      case ShopType.teaHouse:
        writer.writeByte(1);
        break;
      case ShopType.seaFood:
        writer.writeByte(2);
        break;
      case ShopType.jewellery:
        writer.writeByte(3);
        break;
      case ShopType.tropicalFish:
        writer.writeByte(4);
        break;
      case ShopType.florist:
        writer.writeByte(5);
        break;
      case ShopType.takeOut:
        writer.writeByte(6);
        break;
      case ShopType.laundry:
        writer.writeByte(7);
        break;
      case ShopType.dimSum:
        writer.writeByte(8);
        break;
      case ShopType.antiques:
        writer.writeByte(9);
        break;
      case ShopType.factory:
        writer.writeByte(10);
        break;
      case ShopType.restaurant:
        writer.writeByte(11);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
