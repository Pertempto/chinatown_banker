import 'package:hive/hive.dart';

import 'board.dart';
import 'trade.dart';

part 'event.g.dart';

@HiveType(typeId: 2)
class Event extends HiveObject {
  @HiveField(0)
  EventType type;

  @HiveField(1)
  DateTime dateTime;

  @HiveField(2)
  Board? board;

  @HiveField(3)
  Trade? trade;

  Event({
    required this.type,
    required this.dateTime,
    this.board,
    this.trade,
  });

  @override
  String toString() {
    return 'Event, type: $type, date: $dateTime';
  }
}

@HiveType(typeId: 3)
enum EventType {
  @HiveField(0)
  startGame,
  @HiveField(1)
  updateBoard,
  @HiveField(2)
  trade,
  @HiveField(3)
  endOfYear,
}
