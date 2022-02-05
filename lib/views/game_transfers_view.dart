import 'package:flutter/material.dart';

import '../models/game.dart';
import '../models/player.dart';
import 'player_selector.dart';

class GameTransfersView extends StatefulWidget {
  final Game game;

  const GameTransfersView({Key? key, required this.game}) : super(key: key);

  @override
  _GameTransfersViewState createState() => _GameTransfersViewState();
}

class _GameTransfersViewState extends State<GameTransfersView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  /* Allow the user to select a player and amount to transfer */
  _transferMoney(Game game, Player player) async {
    Player? receiver = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerSelector(players: game.players.values.where((p) => p.id != player.id)),
      ),
    );
    if (receiver != null) {
      double maxCash = game.playerCash(player).toDouble();
      int divisions = maxCash ~/ 10;
      showDialog(
        context: context,
        builder: (context) {
          int amount = 10;
          return StatefulBuilder(builder: (context, innerSetState) {
            return AlertDialog(
              title: const Text('Select Amount'),
              contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: [
                      const Text('Amount'),
                      const Spacer(),
                      Text('\$${amount}k'),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Slider(
                      value: amount.toDouble(),
                      onChanged: (value) {
                        innerSetState(() {
                          amount = value.toInt();
                        });
                      },
                      min: 0,
                      max: maxCash,
                      divisions: divisions,
                    ),
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: const Text('Transfer'),
                  onPressed: () {
                    if (amount == 0) {
                      return;
                    }
                    game.transferCash(player, receiver, amount);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
        },
      );
    }
  }
}
