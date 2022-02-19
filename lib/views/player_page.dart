import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../models/game.dart';
import '../models/player.dart';
import 'item.dart';
import 'password_input.dart';

class PlayerPage extends StatefulWidget {
  final int gameKey;
  final String playerId;

  const PlayerPage({Key? key, required this.gameKey, required this.playerId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  late int gameKey = widget.gameKey;
  late String playerId = widget.playerId;
  final Box<Game> gamesBox = Hive.box('games');
  bool editSelected = false;
  bool editLocked = false;
  bool showCash = false;

  bool get editMode => editSelected || editLocked;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: gamesBox.listenable(keys: [gameKey]),
      builder: (context, box, widget) {
        Game game = box.get(gameKey);
        editLocked = !game.isStarted;
        Player? player = game.players[playerId];
        if (player == null) {
          return Container();
        }
        List<Widget> children = [
          if (!editMode) ..._viewWidgets(game, player),
          if (editMode) ..._editWidgets(game, player),
        ];

        return Scaffold(
          appBar: AppBar(
            title: Text(player.name),
            actions: [
              if (editSelected)
                IconButton(
                  icon: const Icon(MdiIcons.eye),
                  onPressed: () => setState(() => editSelected = false),
                ),
              if (!editSelected && !editLocked)
                IconButton(
                  icon: const Icon(MdiIcons.pencil),
                  onPressed: () => setState(() => editSelected = true),
                ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(children: children),
          ),
        );
      },
    );
  }

  /* Get the widgets for the view mode. */
  List<Widget> _viewWidgets(Game game, Player player) {
    int cash = game.playerCash(player);
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: GestureDetector(
          onTapDown: (_) => setState(() => showCash = true),
          onTapCancel: () => setState(() => showCash = false),
          onTapUp: (_) => setState(() => showCash = false),
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: Colors.green.shade700,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Cash', style: textTheme.headline4!.copyWith(color: colorScheme.onPrimary)),
                    const Spacer(),
                    if (!showCash)
                      Text('Press to view', style: textTheme.bodyText1!.copyWith(color: colorScheme.onPrimary)),
                    if (showCash)
                      Text('\$${cash}k', style: textTheme.headline5!.copyWith(color: colorScheme.onPrimary)),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Icon(MdiIcons.cash, color: colorScheme.onPrimary, size: 32),
                    ),
                  ],
                ),
                if (showCash)
                  Row(
                    children: [
                      Expanded(flex: 1, child: Container()),
                      Expanded(
                        flex: 6,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            children: game
                                .playerCashHistory(player)
                                .map((e) => Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(e.title,
                                            style: textTheme.bodyText1!.copyWith(color: colorScheme.onPrimary)),
                                        const Spacer(),
                                        Text(e.amount < 0 ? '(\$${-e.amount}k)' : '\$${e.amount}k',
                                            style: textTheme.bodyText1!.copyWith(color: colorScheme.onPrimary)),
                                      ],
                                    ))
                                .toList(),
                          ),
                        ),
                      ),
                      Expanded(flex: 1, child: Container()),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
      ...game.board.businesses(playerId).map((business) => Item(
            title: business.name,
            backgroundColor: business.color,
            outlined: false,
            trailing: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('(${business.size}/${business.maxSize})',
                  style: textTheme.headline6!.copyWith(color: colorScheme.onPrimary)),
            ),
          ))
    ];
  }

  _editWidgets(Game game, Player player) {
    return [
      Item(
        title: player.name,
        subtitle: 'Tap to edit',
        iconData: MdiIcons.accountCowboyHat,
        onTap: () => _editName(game, player, context),
      ),
      Item(
        title: 'Password',
        subtitle: 'Tap to edit',
        iconData: MdiIcons.lock,
        onTap: () => _editPassword(game, player, context),
      ),
      Item(
        title: 'Color',
        subtitle: 'Tap to change',
        trailing: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: player.tokenColor,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(
              width: 1,
              color: player.contrastColor == Colors.black ? Colors.grey : Colors.transparent,
            ),
          ),
          margin: const EdgeInsets.all(16),
        ),
        onTap: () => setState(() => game.changePlayerColor(player)),
      ),
    ];
  }

  /* Allow the player to edit their name. */
  _editName(Game game, Player player, BuildContext context) {
    TextEditingController textFieldController = TextEditingController(text: player.name);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Change Name'),
          contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(right: 12),
                child: Text('Name:'),
              ),
              Expanded(
                child: TextField(autofocus: true, controller: textFieldController),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                String newName = textFieldController.value.text.trim();
                if (newName.isEmpty) {
                  return;
                }
                game.changePlayerName(player, newName);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  /* Allow the player to edit their password. */
  _editPassword(Game game, Player player, BuildContext context) async {
    if (player.password.isNotEmpty) {
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
        return;
      }
    }
    String? newPassword = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PasswordInput(isNewPassword: true)),
    );
    if (newPassword != null) {
      game.changePlayerPassword(player, newPassword);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Password changed successfully!'),
        duration: Duration(milliseconds: 2000),
      ));
    }
  }
}
