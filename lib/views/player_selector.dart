import 'package:flutter/material.dart';

import '../models/player.dart';

class PlayerSelector extends StatelessWidget {
  final Iterable<Player> players;

  const PlayerSelector({Key? key, required this.players}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Player'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
              children: players
                  .map((player) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context, player),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              color: player.tokenColor,
                            ),
                            child: Row(
                              children: [
                                Text(player.name,
                                    style: textTheme.headline4!.copyWith(
                                        color: colorScheme.onPrimary)),
                                const Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ))
                  .toList()),
        ),
      ),
    );
  }
}
