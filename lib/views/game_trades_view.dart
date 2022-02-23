import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../models/game.dart';
import 'item.dart';
import 'new_trade.dart';

class GameTradesView extends StatefulWidget {
  final Game game;

  const GameTradesView({Key? key, required this.game}) : super(key: key);

  @override
  _GameTradesViewState createState() => _GameTradesViewState();
}

class _GameTradesViewState extends State<GameTradesView> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(children: [
        Item(
          title: 'Trade',
          backgroundColor: Colors.blue,
          iconData: MdiIcons.handshake,
          onTap: () => _startTrade(widget.game),
        ),
      ]),
    );
  }

  _startTrade(Game game) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => NewTrade(game: game)));
  }
}
