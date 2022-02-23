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
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Trade'),
      ),
      backgroundColor: Colors.grey.shade300,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
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
                ElevatedButton.icon(
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
                        _items.add(TradeItem(fromId: sender.id, toId: receiver.id, cash: 0, propertyNumbers: []));
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
