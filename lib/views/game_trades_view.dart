import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../models/game.dart';
import '../models/player.dart';
import 'item.dart';
import 'new_trade.dart';
import 'player_token.dart';

class GameTradesView extends StatefulWidget {
  final Game game;

  const GameTradesView({Key? key, required this.game}) : super(key: key);

  @override
  _GameTradesViewState createState() => _GameTradesViewState();
}

class _GameTradesViewState extends State<GameTradesView> {
  late Game game = widget.game;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(children: [
        Item(
          title: 'Trade',
          backgroundColor: Colors.blue,
          iconData: MdiIcons.handshake,
          onTap: () => _startTrade(widget.game),
        ),
        ...widget.game.tradeEvents.toList().reversed.map(
              (tradeEvent) => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: const ShapeDecoration(
                    shape: ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32))),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Text(Game.dateFormat.format(tradeEvent.dateTime)),
                      Wrap(
                          spacing: 16,
                          children: tradeEvent.trade!.partyIds.map((playerId) {
                            Player player = game.players[playerId]!;
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                PlayerToken(player: player, size: 28, margin: const EdgeInsets.all(4)),
                                Text(player.name, style: textTheme.headline6)
                              ],
                            );
                          }).toList()),
                      // TODO: display items
                    ],
                  )),
            ),
      ]),
    );
  }

  _startTrade(Game game) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NewTrade(game: game)));
  }
}
