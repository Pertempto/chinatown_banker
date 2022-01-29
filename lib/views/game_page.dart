import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../models/business.dart';
import '../models/game.dart';
import '../models/player.dart';
import 'password_input.dart';
import 'player_page.dart';

class GamePage extends StatefulWidget {
  final int gameKey;

  const GamePage({Key? key, required this.gameKey}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late int gameKey = widget.gameKey;
  final Box<Game> gamesBox = Hive.box('games');

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game'),
        actions: [IconButton(icon: const Icon(MdiIcons.delete), onPressed: _delete)],
      ),
      body: ValueListenableBuilder<Box>(
          valueListenable: gamesBox.listenable(keys: [gameKey]),
          builder: (context, box, widget) {
            Game? game = box.get(gameKey);
            if (game == null) {
              return Container();
            }
            return SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          color: Colors.grey.shade300,
                        ),
                        child: Row(
                          children: [
                            Text(game.statusText, style: textTheme.headline4),
                            const Spacer(),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!game.isStarted)
                                  TextButton(onPressed: game.canStart ? game.start : null, child: const Text('Start')),
                                if (game.canGoBack) TextButton(onPressed: game.goBack, child: const Text('Back')),
                                if (game.isPlaying)
                                  TextButton(onPressed: game.completeYear, child: const Text('Next Year')),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    ...game.players.values.map((p) {
                      Iterable<Business> businesses = game.playerBusinesses(p).values;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: GestureDetector(
                          onTap: () => _openPlayer(p),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(8)),
                              color: Color(p.colorValue),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(mainAxisSize: MainAxisSize.min, children: [
                                  Text(p.name, style: textTheme.headline4!.copyWith(color: colorScheme.onPrimary)),
                                  const Spacer(),
                                  Text(businesses.length.toString(),
                                      style: textTheme.headline5!.copyWith(color: colorScheme.onPrimary)),
                                  const SizedBox(width: 8),
                                  Icon(MdiIcons.domain, color: colorScheme.onPrimary),
                                ]),
                                if (!game.isStarted)
                                  Text('Tap to edit',
                                      style: textTheme.subtitle1!.copyWith(color: colorScheme.onPrimary)),
                                if (game.isStarted && businesses.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Wrap(
                                      spacing: 4,
                                      alignment: WrapAlignment.start,
                                      children: businesses.map((b) => _businessChip(b, p)).toList(),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                    if (game.canAddPlayer)
                      OutlinedButton(
                          onPressed: () {
                            int num = game.players.length + 1;
                            game.addPlayer('Player $num', '');
                          },
                          child: const Text('Add Player')),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            );
          }),
    );
  }

  /* Allow the user to delete the game. */
  _delete() {
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
                gamesBox.delete(gameKey);
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

  /* Open the player, using a password prompt if they have a password. */
  _openPlayer(Player player) async {
    if (player.password.isEmpty) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PlayerPage(gameKey: gameKey, playerId: player.id)));
      return;
    }
    String? password = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PasswordInput(isNewPassword: false)),
    );
    if (password == null) {
      return;
    } else if (password != player.password) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Incorrect password.'),
        duration: Duration(milliseconds: 2000),
      ));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PlayerPage(gameKey: gameKey, playerId: player.id)),
      );
    }
  }

  Widget _businessChip(Business business, Player player) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Chip(
      label: Text(business.toString(), style: textTheme.bodyText1!.copyWith(color: colorScheme.onPrimary)),
      visualDensity: VisualDensity.compact,
      backgroundColor: Color(player.colorValue),
      side: const BorderSide(color: Colors.white, width: 1, style: BorderStyle.solid),
      padding: const EdgeInsets.all(0),
    );
  }
}
