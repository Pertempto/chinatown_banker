import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../models/business.dart';
import 'board.dart';
import 'event.dart';
import 'player.dart';

part 'game.g.dart';

class CashRecordEntry {
  final String title;
  final int amount;

  CashRecordEntry(this.title, this.amount);
}

@HiveType(typeId: 1)
class Game extends HiveObject {
  @HiveField(0)
  final DateTime _date;

  DateTime get date => _date;

  static DateFormat dateFormat = DateFormat.yMd().add_jm();

  String get dateString => dateFormat.format(date);

  @HiveField(1)
  final Map<String, Player> _players;

  Map<String, Player> get players => Map.from(_players);

  @HiveField(2, defaultValue: [])
  final List<Event> _events;

  List<Event> get events => _events.toList();

  final Map<String, int> _playerCash;
  final Map<String, List<CashRecordEntry>> _playerCashHistory;
  final Map<String, Map<String, Business>> _playerBusinesses;
  final Board _board = Board();

  Board get board => _board;

  bool get isStarted => _events.isNotEmpty;

  int _year = 1965;

  int get year => _year;

  bool get isComplete => _year > 1970;

  bool get isPlaying => isStarted & !isComplete;

  bool get canAddPlayer => !isStarted && _players.length < 5;

  bool get canStart => !isStarted && _players.length >= 3 && _players.length <= 5;

  bool get canGoBack => isStarted && [EventType.startGame, EventType.endOfYear].contains(_events.last.type);

  Event? get lastBoardEvent {
    Iterable<Event> boardEvents = _events.where((e) => e.type == EventType.updateBoard);
    return boardEvents.isEmpty ? null : boardEvents.last;
  }

  String get statusText {
    if (!isStarted) {
      return 'Setup Game';
    } else if (isComplete) {
      return 'Game Complete';
    } else {
      return year.toString();
    }
  }

  Game.create()
      : _date = DateTime.now(),
        _players = {},
        _events = [],
        _playerCash = {},
        _playerCashHistory = {},
        _playerBusinesses = {} {
    _processEvents();
  }

  Game(this._date, this._players, this._events)
      : _playerCash = {},
        _playerCashHistory = {},
        _playerBusinesses = {} {
    _processEvents();
  }

  // Add a player.
  addPlayer(String name, String password) {
    if (canAddPlayer) {
      Player player = Player(name: name, password: password);
      _players[player.id] = player;
      save();
      _processEvents();
    }
  }

  // Start the game.
  start() {
    if (canStart) {
      _addEvent(Event(type: EventType.startGame, dateTime: DateTime.now()));
    }
  }

  // Complete the current year.
  completeYear() {
    if (isStarted) {
      _addEvent(Event(type: EventType.endOfYear, dateTime: DateTime.now()));
      _addEvent(Event(type: EventType.updateBoard, dateTime: DateTime.now(), board: board.copy()));
    }
  }

  // Remove the last event.
  goBack() {
    if (canGoBack) {
      _events.removeLast();
      save();
      _processEvents();
    }
  }

  // Get the number of thousands of dollars the player has.
  int playerCash(Player player) => _playerCash[player.id] ?? 0;

  // Get a player's cash history.
  List<CashRecordEntry> playerCashHistory(Player player) => List.from(_playerCashHistory[player.id] ?? []);

  // Get the businesses owned by a player.
  Map<String, Business> playerBusinesses(Player player) => Map.from(_playerBusinesses[player.id] ?? {});

  // Change the player's name.
  changePlayerName(Player player, String name) {
    player.name = name;
    _players[player.id] = player;
    save();
  }

  // Change the player's color.
  changePlayerColor(Player player) {
    player.changeColor();
    _players[player.id] = player;
    save();
  }

  // Change the player's password.
  changePlayerPassword(Player player, String password) {
    player.password = password;
    _players[player.id] = player;
    save();
  }

  // Delete the player.
  deletePlayer(Player player) {
    if (!isStarted) {
      _players.remove(player.id);
      save();
    }
  }

  // Transfer money.
  transferCash(Player sender, Player receiver, int amount) {
    if (isPlaying) {
      Event event = Event(
        type: EventType.transferCash,
        dateTime: DateTime.now(),
        senderId: sender.id,
        receiverId: receiver.id,
        amount: amount,
      );
      _addEvent(event);
    }
  }

  // Save the updated board.
  saveBoard() {
    if (isPlaying) {
      Event event = Event(type: EventType.updateBoard, dateTime: DateTime.now(), board: _board.copy());
      _addEvent(event);
    }
  }

  _addEvent(Event event) {
    _events.add(event);
    _processEvent(event);
    save();
  }

  _processEvents() {
    _year = 1965;
    _playerCash.clear();
    _playerCashHistory.clear();
    for (Player player in _players.values) {
      _playerCash[player.id] = 50;
      _playerCashHistory[player.id] = [CashRecordEntry('Initial Cash', 50)];
    }
    _playerBusinesses.clear();
    _events.forEach(_processEvent);
  }

  _processEvent(Event event) {
    if (event.type == EventType.transferCash) {
      Player sender = _players[event.senderId]!;
      Player receiver = _players[event.receiverId]!;
      int amount = event.amount!;
      _playerCash[sender.id] = _playerCash[sender.id]! - amount;
      _playerCashHistory[sender.id]!.add(CashRecordEntry('Transfer to ${receiver.name}', -amount));
      _playerCash[receiver.id] = _playerCash[receiver.id]! + amount;
      _playerCashHistory[receiver.id]!.add(CashRecordEntry('Transfer from ${sender.name}', amount));
    } else if (event.type == EventType.updateBoard) {
      _board.set(event.board!);
    } else if (event.type == EventType.endOfYear) {
      for (Player player in _players.values) {
        int income = 0;
        for (Business business in playerBusinesses(player).values) {
          income += business.value;
        }
        _playerCash[player.id] = _playerCash[player.id]! + income;
        _playerCashHistory[player.id]!.add(CashRecordEntry('$year Income', income));
      }
      _year++;
    }
  }
}
