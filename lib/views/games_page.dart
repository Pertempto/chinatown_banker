import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/game.dart';
import 'game_page.dart';

class GamesPage extends StatefulWidget {
  const GamesPage({Key? key}) : super(key: key);

  @override
  State<GamesPage> createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  late Box<Game> gamesBox = Hive.box('games');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Games')),
      body: ValueListenableBuilder<Box>(
        valueListenable: gamesBox.listenable(),
        builder: (context, box, widget) => ListView(
          padding: const EdgeInsets.all(12),
          children: box.keys
              .map<Widget>((k) {
                Game game = box.get(k);
                return _gameWidget(game);
              })
              .toList()
              .reversed
              .toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addGame,
        tooltip: 'New Game',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _gameWidget(Game game) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => GamePage(gameKey: game.key))),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(game.dateString, style: textTheme.headline6),
              if (game.players.isNotEmpty) const SizedBox(height: 8),
              Wrap(
                  spacing: 16,
                  children: game.players.values.map((player) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(4),
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: player.color,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            border: Border.all(
                              width: 1,
                              color: player.color == Colors.white
                                  ? Colors.grey
                                  : Colors.transparent,
                            ),
                            // color: Color(player.colorValue),
                          ),
                        ),
                        Text(player.name, style: textTheme.headline6)
                      ],
                    );
                  }).toList()),
            ],
          ),
        ),
      ),
    );
  }

  _addGame() {
    gamesBox.add(Game.create()).then((gameKey) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => GamePage(gameKey: gameKey)));
    });
  }
}
