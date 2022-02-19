import 'package:hive/hive.dart';

import 'board.dart';

part 'event.g.dart';

@HiveType(typeId: 3)
class Event extends HiveObject {
  @HiveField(0)
  EventType type;

  @HiveField(1)
  DateTime dateTime;

  @HiveField(2)
  Board? board;

  @HiveField(3)
  String? senderId;

  @HiveField(4)
  String? receiverId;

  @HiveField(5)
  int? amount;

  Event({
    required this.type,
    required this.dateTime,
    this.board,
    this.senderId,
    this.receiverId,
    this.amount,
  });
}

@HiveType(typeId: 4)
enum EventType {
  @HiveField(0)
  startGame,
  @HiveField(1)
  transferCash,
  @HiveField(2)
  updateBoard,
  @HiveField(3)
  endOfYear,
}
