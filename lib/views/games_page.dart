import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
    TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Games')),
      body: ValueListenableBuilder<Box>(
        valueListenable: gamesBox.listenable(),
        builder: (context, box, widget) => ListView(
          children: box.keys
              .map<Widget>((k) {
                Game game = box.get(k);
                return ListTile(
                  title: Text(game.dateString, style: textTheme.headline5),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(game.players.length.toString(), style: textTheme.subtitle1),
                      const SizedBox(width: 8),
                      const Icon(MdiIcons.accountGroup),
                    ],
                  ),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => GamePage(gameKey: k))),
                );
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

  _addGame() {
    gamesBox.add(Game.create()).then((gameKey) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => GamePage(gameKey: gameKey)));
    });
  }
}
