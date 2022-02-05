import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../models/game.dart';
import 'board_view.dart';
import 'game_players_view.dart';
import 'game_settings_view.dart';
import 'game_transfers_view.dart';

class GamePage extends StatefulWidget {
  final int gameKey;

  const GamePage({Key? key, required this.gameKey}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> with TickerProviderStateMixin {
  late int gameKey = widget.gameKey;
  final Box<Game> gamesBox = Hive.box('games');
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
        valueListenable: gamesBox.listenable(keys: [gameKey]),
        builder: (context, box, widget) {
          Game? game = box.get(gameKey);
          if (game == null) {
            return Container();
          }
          return Scaffold(
              appBar: AppBar(
                title: const Text('Game'),
                bottom: TabBar(
                  controller: _tabController,
                  tabs: const <Widget>[
                    Tab(icon: Icon(MdiIcons.viewDashboard)),
                    Tab(icon: Icon(MdiIcons.accountMultiple)),
                    Tab(icon: Icon(MdiIcons.cash)),
                    Tab(icon: Icon(MdiIcons.cog)),
                  ],
                ),
              ),
              body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  BoardView(game: game),
                  GamePlayersView(game: game),
                  GameTransfersView(game: game),
                  GameSettingsView(game: game),
                ],
              ));
        });
  }
}
