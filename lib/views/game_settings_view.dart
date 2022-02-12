import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../models/game.dart';
import 'item.dart';

class GameSettingsView extends StatefulWidget {
  final Game game;

  const GameSettingsView({Key? key, required this.game}) : super(key: key);

  @override
  _GameSettingsViewState createState() => _GameSettingsViewState();
}

class _GameSettingsViewState extends State<GameSettingsView> {
  final Box<Game> gamesBox = Hive.box('games');

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(children: [
          Item(
            title: 'Delete Game',
            outlined: false,
            backgroundColor: Colors.red,
            iconData: MdiIcons.delete,
            onTap: () => _delete(widget.game),
          ),
        ]),
      ),
    );
  }

  /* Allow the user to delete the game. */
  _delete(Game game) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Game'),
          contentPadding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
          content: const Text('Are you sure? This is permanent.'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                gamesBox.delete(game.key);
                Navigator.pop(context);
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
