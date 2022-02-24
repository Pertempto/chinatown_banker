import 'package:chinatown_banker/views/trade_item_view.dart';
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
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: const ShapeDecoration(
                    shape: ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32))),
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      Text(Game.dateFormat.format(tradeEvent.dateTime), style: textTheme.headline6),
                      ...tradeEvent.trade!.tradeItems.map((item) => TradeItemView(game: game, item: item, small: true)),
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
