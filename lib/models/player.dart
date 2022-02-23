import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'player.g.dart';

String _randomKey() {
  String id = '';
  String options = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  Random rand = Random();
  for (int i = 0; i < 2; i++) {
    id += options[rand.nextInt(options.length)];
  }
  return id;
}

@HiveType(typeId: 4)
class Player extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String password;

  @HiveField(3, defaultValue: PlayerColor.green)
  PlayerColor color;

  Color get tokenColor => _convertColor(color);

  Color get contrastColor => _contrastColor(color);

  Player({required this.name, required this.password, required this.color})
      : id = _randomKey();

  // Change the player's color to the next color.
  changeColor() {
    color = PlayerColor.values[(PlayerColor.values.indexOf(color) + 1) % PlayerColor.values.length];
  }
}

@HiveType(typeId: 5)
enum PlayerColor {
  @HiveField(0)
  green,
  @HiveField(1)
  purple,
  @HiveField(2)
  red,
  @HiveField(3)
  white,
  @HiveField(4)
  yellow,
}

Color _convertColor(PlayerColor color) {
  return {
        PlayerColor.green: Colors.green.shade500,
        PlayerColor.purple: Colors.purple,
        PlayerColor.red: Colors.red,
        PlayerColor.white: Colors.white,
        PlayerColor.yellow: Colors.yellow,
      }[color] ??
      Colors.black;
}

Color _contrastColor(PlayerColor color) {
  return {
        PlayerColor.green: Colors.white,
        PlayerColor.purple: Colors.white,
        PlayerColor.red: Colors.white,
        PlayerColor.white: Colors.black,
        PlayerColor.yellow: Colors.black,
      }[color] ??
      Colors.black;
}
