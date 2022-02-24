import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../models/game.dart';
import '../models/player.dart';
import '../models/trade.dart';
import 'player_token.dart';
import 'property_number_item.dart';

class TradeItemView extends StatelessWidget {
  final Game game;
  final TradeItem item;
  final VoidCallback? onCashTap;
  final Widget? bottom;
  final bool small;

  const TradeItemView({
    Key? key,
    required this.game,
    required this.item,
    this.onCashTap,
    this.bottom,
    this.small = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle textStyle = small ? textTheme.subtitle1! : textTheme.headline6!;
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    Player sender = game.players[item.fromId]!;
    Player receiver = game.players[item.toId]!;
    return Container(
      margin: EdgeInsets.only(bottom: small ? 0 : 8),
      decoration: const ShapeDecoration(
        shape: ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32))),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PlayerToken(player: sender, size: small ? 28 : 40, margin: EdgeInsets.all(small ? 8 : 12)),
                    Text(sender.name, style: textStyle.copyWith(color: Colors.grey.shade800)),
                  ],
                ),
              ),
              const Expanded(flex: 1, child: Icon(MdiIcons.arrowRight)),
              Expanded(
                flex: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(receiver.name, style: textStyle.copyWith(color: Colors.grey.shade800)),
                    PlayerToken(player: receiver, size: small ? 28 : 40, margin: EdgeInsets.all(small ? 8 : 12)),
                  ],
                ),
              ),
            ],
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: small ? 4 : 8, horizontal: small ? 6 : 12),
                decoration: ShapeDecoration(
                  shape: ContinuousRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(small ? 12 : 24))),
                  color: Colors.green.shade700,
                ),
                child: GestureDetector(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(MdiIcons.cash, color: colorScheme.onPrimary, size: small ? 24 : 32),
                      const SizedBox(width: 8),
                      Text('\$${item.cash}k', style: textStyle.copyWith(color: colorScheme.onPrimary)),
                    ],
                  ),
                  onTap: onCashTap,
                ),
              ),
              ...item.propertyNumbers.map((propertyNumber) => PropertyNumberItem(
                    propertyNumber: propertyNumber,
                    small: small,
                  )),
            ],
          ),
          if (bottom != null) bottom!,
          if (bottom == null)  SizedBox(height: small ? 4 : 8),
        ],
      ),
    );
  }
}
