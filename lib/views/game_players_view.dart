import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/business.dart';
import '../models/game.dart';
import '../models/player.dart';
import 'item.dart';
import 'password_input.dart';
import 'player_page.dart';
import 'player_token.dart';

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
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Item(
              title: game.statusText,
              trailing: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!game.isStarted)
                      TextButton(onPressed: game.canStart ? game.start : null, child: const Text('Start')),
                    if (game.canGoBack) TextButton(onPressed: game.goBack, child: const Text('Back')),
                    if (game.isPlaying) TextButton(onPressed: game.completeYear, child: const Text('Next Year')),
                  ],
                ),
              ),
            ),
            ...game.players.values.map((player) {
              List<Business> businesses = game.board.businesses(player.id);
              return Item(
                title: player.name,
                leading: PlayerToken(player: player),
                onTap: () => _openPlayer(player),
                content: (game.isStarted && businesses.isNotEmpty)
                    ? Padding(
                        padding: const EdgeInsets.all(8),
                        child: Wrap(
                          spacing: 4,
                          runSpacing: 4,
                          children: businesses.map((b) => _businessWidget(b, player)).toList(),
                        ),
                      )
                    : null,
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

  /* A small widget representing a business. */
  Widget _businessWidget(Business business, Player player) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      child: Text(business.toString(),
          style: textTheme.bodyText1!.copyWith(
            color: business.color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
          )),
      padding: const EdgeInsets.all(8),
      decoration: ShapeDecoration(
        shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: business.color,
      ),
    );
  }
}
