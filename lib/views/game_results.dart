import 'package:flutter/material.dart';

import '../models/game.dart';
import '../models/player.dart';
import 'item.dart';

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
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...List.generate(sortedPlayers.length, (index) {
                Player player = sortedPlayers[index];
                return Item(
                  leading: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      '#${index + 1}',
                      style: textTheme.headline5,
                    ),
                  ),
                  title: isShowing[index] ? player.name : "Tap to show",
                  trailing: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      isShowing[index] ? "\$${game.playerCash(player)}k" : "?",
                      style: textTheme.headline4,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      isShowing[index] = true;
                    });
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
