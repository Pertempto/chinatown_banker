import 'dart:math';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../models/game.dart';
import '../models/player.dart';
import '../models/trade.dart';
import 'item.dart';
import 'player_token.dart';

class NewTrade extends StatefulWidget {
  final Game game;

  const NewTrade({Key? key, required this.game}) : super(key: key);

  @override
  _NewTradeState createState() => _NewTradeState();
}

class _NewTradeState extends State<NewTrade> {
  late Game game = widget.game;
  final List<Player> _selectedPlayers = [];
  List<TradeItem> _items = [];

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Trade'),
        actions: [
          if (_items.isNotEmpty) IconButton(onPressed: () {}, icon: const Icon(MdiIcons.check)),
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
                    trailing: const Padding(padding: EdgeInsets.all(16), child: Text('Tap to remove')),
                    onTap: () => setState(() {
                      _selectedPlayers.remove(player);
                      _items = _items.where((item) => item.toId != player.id && item.fromId != player.id).toList();
                    }),
                  )),
              if (game.players.values.any((player) => !_selectedPlayers.contains(player)))
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
                  child: ElevatedButton.icon(
                    icon: const Icon(MdiIcons.accountPlus),
                    label: const Text('Add Player'),
                    onPressed: () {
                      _selectPlayer(
                        title: 'Add Player',
                        options: game.players.values.where((player) => !_selectedPlayers.contains(player)),
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
                Player sender = game.players[item.fromId]!;
                Player receiver = game.players[item.toId]!;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: const ShapeDecoration(
                    shape: ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32))),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                PlayerToken(player: sender),
                                Text(sender.name, style: textTheme.headline6!.copyWith(color: Colors.grey.shade800)),
                              ],
                            ),
                          ),
                          const Expanded(flex: 1, child: Icon(MdiIcons.arrowRight)),
                          Expanded(
                            flex: 4,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(receiver.name, style: textTheme.headline6!.copyWith(color: Colors.grey.shade800)),
                                PlayerToken(player: receiver),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            decoration: ShapeDecoration(
                              shape: const ContinuousRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(24)),
                              ),
                              color: Colors.green.shade700,
                            ),
                            child: GestureDetector(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(MdiIcons.cash, color: colorScheme.onPrimary, size: 32),
                                  const SizedBox(width: 8),
                                  Text('\$${item.cash}k',
                                      style: textTheme.headline6!.copyWith(color: colorScheme.onPrimary)),
                                ],
                              ),
                              onTap: () {
                                // TODO: change cash amount.
                              },
                            ),
                          ),
                          ...item.propertyNumbers.map((propertyNumber) => Container(
                                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                decoration: ShapeDecoration(
                                  shape: const ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(24)),
                                  ),
                                  color: Colors.blue.shade700,
                                ),
                                child: GestureDetector(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(MdiIcons.store, color: colorScheme.onPrimary, size: 32),
                                      const SizedBox(width: 8),
                                      Text(
                                        '#$propertyNumber',
                                        style: textTheme.headline6!.copyWith(color: colorScheme.onPrimary),
                                      ),
                                    ],
                                  ),
                                  onTap: () => setState(() => item.propertyNumbers.remove(propertyNumber)),
                                ),
                              )),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => setState(() {
                                // TODO: show dialog to select property number
                                Random rand = Random();
                                item.propertyNumbers.add(rand.nextInt(85) + 1);
                              }),
                              icon: const Icon(MdiIcons.storePlus),
                            ),
                            IconButton(
                              onPressed: () => setState(() => _items.remove(item)),
                              icon: const Icon(MdiIcons.close),
                            ),
                          ],
                        ),
                      ),
                    ],
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
                      options: _selectedPlayers.where((player) => player != sender),
                      callback: (receiver) {
                        setState(() {
                          _items.add(TradeItem(fromId: sender.id, toId: receiver.id, cash: 0, propertyNumbers: []));
                        });
                      },
                    );
                  },
                );
              },
            ),
    );
  }

  _selectPlayer({required String title, required Iterable<Player> options, required Function(Player) callback}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.grey.shade300,
            shape: const ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32))),
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
}
