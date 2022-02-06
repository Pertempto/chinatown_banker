import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/business.dart';
import '../models/game.dart';
import '../models/player.dart';
import 'outlined_item.dart';
import 'password_input.dart';
import 'player_page.dart';

class GamePlayersView extends StatefulWidget {
  final Game game;

  const GamePlayersView({Key? key, required this.game}) : super(key: key);

  @override
  _GamePlayersViewState createState() => _GamePlayersViewState();
}

class _GamePlayersViewState extends State<GamePlayersView> {
  late Game game = widget.game;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
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
                        if (game.isPlaying) TextButton(onPressed: game.completeYear, child: const Text('Next Year')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ...game.players.values.map((player) {
              Iterable<Business> businesses = game.playerBusinesses(player).values;
              return OutlinedItem(
                title: player.name,
                leading: Container(
                  margin: const EdgeInsets.all(12),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: player.color,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    border: Border.all(
                      width: 1,
                      color: player.color == Colors.white ? Colors.grey : Colors.transparent,
                    ),
                    // color: Color(player.colorValue),
                  ),
                ),
                onTap: () => _openPlayer(player),
              );
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  onTap: () => _openPlayer(player),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      border: Border.all(width: 2, color: Colors.grey),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(mainAxisSize: MainAxisSize.min, children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: player.color,
                              borderRadius: const BorderRadius.all(Radius.circular(20)),
                              border: Border.all(
                                width: 1,
                                color: player.color == Colors.white ? Colors.grey : Colors.transparent,
                              ),
                              // color: Color(player.colorValue),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Text(player.name, style: textTheme.headline4),
                          const Spacer(),
                          // Text(businesses.length.toString(), style: textTheme.headline5),
                          // const SizedBox(width: 8),
                          // const Icon(MdiIcons.domain),
                        ]),
                        if (!game.isStarted) Text('Tap to edit', style: textTheme.subtitle1),
                        if (game.isStarted && businesses.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Wrap(
                              spacing: 4,
                              alignment: WrapAlignment.start,
                              children: businesses.map((b) => _businessChip(b, player)).toList(),
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
  }

  /* Open the player, using a password prompt if they have a password. */
  _openPlayer(Player player) async {
    if (player.password.isEmpty) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PlayerPage(gameKey: game.key, playerId: player.id)));
      return;
    }
    if (kDebugMode) {
      print('Player password ${player.password}');
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
        MaterialPageRoute(builder: (context) => PlayerPage(gameKey: game.key, playerId: player.id)),
      );
    }
  }

  Widget _businessChip(Business business, Player player) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Chip(
      label: Text(business.toString(), style: textTheme.bodyText1),
      visualDensity: VisualDensity.compact,
      backgroundColor: Colors.transparent,
      side: const BorderSide(
        color: Colors.grey,
        width: 2,
        style: BorderStyle.solid,
      ),
      padding: const EdgeInsets.all(0),
    );
  }
}
