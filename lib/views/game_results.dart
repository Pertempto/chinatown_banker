import 'package:chinatown_banker/views/result_item.dart';
import 'package:flutter/material.dart';

import '../models/game.dart';
import '../models/player.dart';

class GameResults extends StatefulWidget {
  final Game game;

  const GameResults({Key? key, required this.game}) : super(key: key);

  @override
  _GameResultsState createState() => _GameResultsState();
}

class _GameResultsState extends State<GameResults> {
  late Game game = widget.game;
  late List<bool> isShowing =
      List.generate(game.players.length, (index) => false);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    List<Player> sortedPlayers = game.players.values.toList();
    sortedPlayers.sort(
      (p1, p2) => -game.playerCash(p1).compareTo(game.playerCash(p2)),
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Results')),
      backgroundColor: Colors.grey.shade300,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...List.generate(sortedPlayers.length, (index) {
                Player player = sortedPlayers[index];
                return ResultItem(
                  number: index + 1,
                  player: player,
                  cash: game.playerCash(player),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
