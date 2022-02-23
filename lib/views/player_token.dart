import 'package:flutter/material.dart';

import '../models/player.dart';

class PlayerToken extends StatelessWidget {
  final Player player;
  final double size;
  final EdgeInsets margin;

  const PlayerToken({
    Key? key,
    required this.player,
    this.size = 40,
    this.margin = const EdgeInsets.all(12),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: player.tokenColor,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(
          width: 1,
          color: player.tokenColor == Colors.white ? Colors.grey : Colors.transparent,
        ),
      ),
    );
  }
}
