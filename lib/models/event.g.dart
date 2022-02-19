// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventAdapter extends TypeAdapter<Event> {
  @override
  final int typeId = 3;

  @override
  Event read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Event(
      type: fields[0] as EventType,
      dateTime: fields[1] as DateTime,
      board: fields[2] as Board?,
      senderId: fields[3] as String?,
      receiverId: fields[4] as String?,
      amount: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Event obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.dateTime)
      ..writeByte(2)
      ..write(obj.board)
      ..writeByte(3)
      ..write(obj.senderId)
      ..writeByte(4)
      ..write(obj.receiverId)
      ..writeByte(5)
      ..write(obj.amount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EventTypeAdapter extends TypeAdapter<EventType> {
  @override
  final int typeId = 4;

  @override
  EventType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return EventType.startGame;
      case 1:
        return EventType.transferCash;
      case 2:
        return EventType.updateBoard;
      case 3:
        return EventType.endOfYear;
      default:
        return EventType.startGame;
    }
  }

  @override
  void write(BinaryWriter writer, EventType obj) {
    switch (obj) {
      case EventType.startGame:
        writer.writeByte(0);
        break;
      case EventType.transferCash:
        writer.writeByte(1);
        break;
      case EventType.updateBoard:
        writer.writeByte(2);
        break;
      case EventType.endOfYear:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
