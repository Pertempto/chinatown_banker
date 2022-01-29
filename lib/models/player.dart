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

List<Color> playerColors = [
  Colors.red,
  Colors.purple,
  Colors.yellow,
  Colors.green,
  Colors.white,
];

Color _randomColor() {
  Random rand = Random();
  return playerColors[rand.nextInt(playerColors.length)];
}

@HiveType(typeId: 2)
class Player extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String password;

  @HiveField(3)
  int colorValue;

  Player({required this.name, required this.password})
      : id = _randomKey(),
        colorValue = _randomColor().value;

  // Change the player's color to a different random color.
  changeColor() {
    int newColorValue = colorValue;
    while (newColorValue == colorValue) {
      newColorValue = _randomColor().value;
    }
    colorValue = newColorValue;
  }
}
