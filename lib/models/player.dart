import 'dart:math';
import 'dart:ui';

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

@HiveType(typeId: 2)
class Player extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String password;

  @HiveField(4, defaultValue: PlayerColor.green)
  PlayerColor _color;

  Color get color => _convertColor(_color);

  Color get contrastColor => _contrastColor(_color);

  Player({required this.name, required this.password})
      : id = _randomKey(),
        _color = _randomColor();

  // Change the player's color to a different random color.
  changeColor() {
    PlayerColor newColorName = _color;
    while (newColorName == _color) {
      newColorName = _randomColor();
    }
    _color = newColorName;
  }
}

@HiveType(typeId: 7)
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

PlayerColor _randomColor() {
  Random rand = Random();
  return PlayerColor.values[rand.nextInt(PlayerColor.values.length)];
}

Color _convertColor(PlayerColor color) {
  return {
        PlayerColor.green: Colors.green,
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
