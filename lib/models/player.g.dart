// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerAdapter extends TypeAdapter<Player> {
  @override
  final int typeId = 2;

  @override
  Player read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Player(
      name: fields[1] as String,
      password: fields[2] as String,
    )
      ..id = fields[0] as String
      .._color =
          fields[4] == null ? PlayerColor.green : fields[4] as PlayerColor;
  }

  @override
  void write(BinaryWriter writer, Player obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj._color);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlayerColorAdapter extends TypeAdapter<PlayerColor> {
  @override
  final int typeId = 7;

  @override
  PlayerColor read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PlayerColor.green;
      case 1:
        return PlayerColor.purple;
      case 2:
        return PlayerColor.red;
      case 3:
        return PlayerColor.white;
      case 4:
        return PlayerColor.yellow;
      default:
        return PlayerColor.green;
    }
  }

  @override
  void write(BinaryWriter writer, PlayerColor obj) {
    switch (obj) {
      case PlayerColor.green:
        writer.writeByte(0);
        break;
      case PlayerColor.purple:
        writer.writeByte(1);
        break;
      case PlayerColor.red:
        writer.writeByte(2);
        break;
      case PlayerColor.white:
        writer.writeByte(3);
        break;
      case PlayerColor.yellow:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerColorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
