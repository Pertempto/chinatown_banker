import 'package:flutter/material.dart';

import '../models/player.dart';
import 'player_token.dart';

class ResultItem extends StatefulWidget {
  final int number;
  final Player player;
  final int cash;

  const ResultItem({
    Key? key,
    required this.number,
    required this.player,
    required this.cash,
  }) : super(key: key);

  @override
  _ResultItemState createState() => _ResultItemState();
}

class _ResultItemState extends State<ResultItem> {
  final Duration _animationDuration = const Duration(milliseconds: 1000);
  bool _isShowing = false;

  double get _opacityLevel => _isShowing ? 1 : 0;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: const ShapeDecoration(
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32))),
          color: Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('#${widget.number}', style: textTheme.headlineMedium),
            const SizedBox(width: 16),
            AnimatedOpacity(
              opacity: _opacityLevel,
              duration: _animationDuration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PlayerToken(player: widget.player, margin: EdgeInsets.zero),
                  const SizedBox(width: 16),
                  Text(widget.player.name, style: textTheme.headlineMedium),
                ],
              ),
            ),
            const Spacer(),
            AnimatedOpacity(
              opacity: _opacityLevel,
              duration: _animationDuration,
              child: Text("\$${widget.cash}k", style: textTheme.headlineMedium),
            ),
          ],
        ),
      ),
      onTap: () => setState(() => _isShowing = !_isShowing),
    );
  }
}
