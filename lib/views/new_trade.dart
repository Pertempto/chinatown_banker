import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../models/game.dart';
import '../models/player.dart';
import '../models/trade.dart';
import 'item.dart';
import 'password_input.dart';
import 'player_token.dart';
import 'property_number_item.dart';
import 'trade_item_view.dart';

class NewTrade extends StatefulWidget {
  final Game game;

  const NewTrade({Key? key, required this.game}) : super(key: key);

  @override
  _NewTradeState createState() => _NewTradeState();
}

class _NewTradeState extends State<NewTrade> {
  late Game game = widget.game;
  final List<Player> _selectedPlayers = [];
  final Map<String, bool> _playerApproval = {};
  List<TradeItem> _items = [];

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    List<int> alreadyTradeProperties = [];
    for (TradeItem item in _items) {
      alreadyTradeProperties.addAll(item.propertyNumbers);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Trade'),
        actions: [
          IconButton(
              onPressed: _completeTrade, icon: const Icon(MdiIcons.check))
        ],
      ),
      backgroundColor: Colors.grey.shade300,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              if (_selectedPlayers.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
                  child: Text('Trade Partners', style: textTheme.headline4),
                ),
              ..._selectedPlayers.map((player) => Item(
                    title: player.name,
                    leading: PlayerToken(player: player),
                    trailing: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Icon(MdiIcons.check,
                            color: (_playerApproval[player.id] ?? false)
                                ? Colors.black
                                : Colors.grey)),
                    onTap: () => _playerDialog(player),
                  )),
              if (game.players.values
                  .any((player) => !_selectedPlayers.contains(player)))
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
                  child: ElevatedButton.icon(
                    icon: const Icon(MdiIcons.accountPlus),
                    label: const Text('Add Player'),
                    onPressed: () {
                      _selectPlayer(
                        title: 'Add Player',
                        options: game.players.values.where(
                            (player) => !_selectedPlayers.contains(player)),
                        callback: (player) {
                          setState(() {
                            _selectedPlayers.add(player);
                          });
                        },
                      );
                    },
                  ),
                ),
              if (_items.isNotEmpty) const Divider(),
              if (_items.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
                  child: Text('Trade Items', style: textTheme.headline4),
                ),
              ..._items.map((item) {
                return TradeItemView(
                  game: game,
                  item: item,
                  onCashTap: () => _selectCash(
                      currentCash: item.cash,
                      callback: (cash) => setState(() => item.cash = cash)),
                  bottom: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => _selectPropertyNumber(
                              title: 'Add Property',
                              options: game.board
                                  .getPropertyNumbers(item.fromId)
                                  .where((n) =>
                                      !alreadyTradeProperties.contains(n)),
                              callback: (propertyNumber) {
                                setState(() {
                                  item.propertyNumbers.add(propertyNumber);
                                });
                              }),
                          icon: const Icon(MdiIcons.storePlus),
                        ),
                        IconButton(
                          onPressed: () => _selectPropertyNumber(
                              title: 'Remove Property',
                              options: item.propertyNumbers,
                              callback: (propertyNumber) {
                                setState(() {
                                  item.propertyNumbers.remove(propertyNumber);
                                });
                              }),
                          icon: const Icon(MdiIcons.storeMinus),
                        ),
                        IconButton(
                          onPressed: () => _removeTradeItem(item),
                          icon: const Icon(MdiIcons.close),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: _selectedPlayers.length < 2
          ? null
          : FloatingActionButton(
              child: const Icon(MdiIcons.plus),
              onPressed: () {
                _selectPlayer(
                  title: 'Sender',
                  options: _selectedPlayers,
                  callback: (sender) {
                    _selectPlayer(
                      title: 'Receiver',
                      options:
                          _selectedPlayers.where((player) => player != sender),
                      callback: (receiver) {
                        setState(() {
                          _playerApproval.clear();
                          _items.add(TradeItem(
                              fromId: sender.id,
                              toId: receiver.id,
                              cash: 0,
                              propertyNumbers: []));
                        });
                      },
                    );
                  },
                );
              },
            ),
    );
  }

  _completeTrade() {
    if (_items.isEmpty) {
      _errorMessage('No trade items');
      return;
    }
    if (!_items
        .every((item) => item.cash != 0 || item.propertyNumbers.isNotEmpty)) {
      _errorMessage('Some of the trade items are empty.');
      return;
    }
    Map<String, int> moneySpent = Map.fromEntries(
        _selectedPlayers.map((player) => MapEntry(player.id, 0)));
    for (TradeItem item in _items) {
      moneySpent[item.fromId] = moneySpent[item.fromId]! + item.cash;
    }
    if (_selectedPlayers
        .any((player) => moneySpent[player.id]! > game.playerCash(player))) {
      _errorMessage('Some player has insufficient funds.');
      return;
    }
    if (_selectedPlayers.any((player) => _playerApproval[player.id] != true)) {
      _errorMessage('Trade has not received full approval.');
      return;
    }

    Navigator.of(context).pop();
    // Only include the players that actually participated in the trade items.
    Set<String> partyIds = {};
    for (TradeItem item in _items) {
      partyIds.add(item.fromId);
      partyIds.add(item.toId);
    }
    game.addTrade(Trade(partyIds: partyIds.toList(), tradeItems: _items));
  }

  _errorMessage(String message) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          title: Text('Invalid Trade',
              style:
                  textTheme.headline6!.copyWith(color: colorScheme.onPrimary)),
          content: Text(message,
              style:
                  textTheme.subtitle1!.copyWith(color: colorScheme.onPrimary)),
        );
      },
    );
  }

  _playerDialog(Player player) {
    TextTheme textTheme = Theme.of(context).textTheme;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade300,
            contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Item(
                  title: 'Remove',
                  backgroundColor: Colors.red,
                  textStyle: textTheme.headline5,
                  iconData: MdiIcons.delete,
                  onTap: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _selectedPlayers.remove(player);
                      _playerApproval.clear();
                      _items = _items
                          .where((item) =>
                              item.toId != player.id &&
                              item.fromId != player.id)
                          .toList();
                    });
                  },
                ),
                if (_playerApproval[player.id] == true)
                  Item(
                      title: 'Disapprove',
                      backgroundColor: Colors.blue,
                      textStyle: textTheme.headline5,
                      iconData: MdiIcons.check,
                      onTap: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _playerApproval[player.id] = false;
                        });
                      }),
                if (_playerApproval[player.id] != true)
                  Item(
                    title: 'Approve',
                    backgroundColor: Colors.blue,
                    textStyle: textTheme.headline5,
                    iconData: MdiIcons.check,
                    onTap: () async {
                      void giveApproval() {
                        Navigator.of(context).pop();
                        setState(() {
                          _playerApproval[player.id] = true;
                        });
                      }

                      if (player.password.isEmpty) {
                        giveApproval();
                      } else {
                        String? password = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const PasswordInput(isNewPassword: false)));
                        if (password == null) {
                          return;
                        } else if (password != player.password) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text('Incorrect password.'),
                            duration: Duration(milliseconds: 2000),
                          ));
                        } else {
                          giveApproval();
                        }
                      }
                    },
                  ),
              ],
            ),
          );
        });
  }

  _selectPlayer(
      {required String title,
      required Iterable<Player> options,
      required Function(Player) callback}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade300,
            title: Text(title),
            contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...options.map((player) => Item(
                      title: player.name,
                      leading: PlayerToken(player: player),
                      onTap: () {
                        Navigator.of(context).pop();
                        callback(player);
                      },
                    ))
              ],
            ),
          );
        });
  }

  _selectCash({required int currentCash, required Function(int) callback}) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, innerSetState) {
            return AlertDialog(
              backgroundColor: Colors.green.shade700,
              contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('\$${currentCash}k',
                      style: textTheme.headline2!
                          .copyWith(color: colorScheme.onPrimary)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => innerSetState(() {
                          currentCash = 0;
                          callback(currentCash);
                        }),
                        icon: Icon(MdiIcons.cashRemove,
                            color: colorScheme.onPrimary),
                      ),
                      IconButton(
                        onPressed: currentCash < 10
                            ? null
                            : () => innerSetState(() {
                                  currentCash -= 10;
                                  callback(currentCash);
                                }),
                        icon: Icon(MdiIcons.cashMinus,
                            color: colorScheme.onPrimary),
                      ),
                      IconButton(
                        onPressed: () => innerSetState(() {
                          currentCash += 10;
                          callback(currentCash);
                        }),
                        icon: Icon(MdiIcons.cashPlus,
                            color: colorScheme.onPrimary),
                      ),
                      IconButton(
                        onPressed: () => innerSetState(() {
                          currentCash += 100;
                          callback(currentCash);
                        }),
                        icon: Icon(MdiIcons.cash100,
                            color: colorScheme.onPrimary),
                      ),
                    ],
                  ),
                ],
              ),
            );
          });
        });
  }

  _selectPropertyNumber(
      {required String title,
      required Iterable<int> options,
      required Function(int) callback}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade300,
            title: Text(title),
            contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            content: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ...options.map((propertyNumber) => PropertyNumberItem(
                      propertyNumber: propertyNumber,
                      onTap: () {
                        Navigator.of(context).pop();
                        callback(propertyNumber);
                      },
                    ))
              ],
            ),
          );
        });
  }

  /* Allow the user to remove an item. */
  _removeTradeItem(TradeItem item) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove Trade Item'),
          contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
          content: const Text('Are you sure?'),
          actions: <Widget>[
            TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop()),
            TextButton(
              child: const Text('Remove'),
              onPressed: () {
                setState(() {
                  _playerApproval.clear();
                  _items.remove(item);
                });
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(primary: Colors.red),
            ),
          ],
        );
      },
    );
  }
}
