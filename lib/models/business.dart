import 'dart:math';

import 'package:flutter/material.dart';

import 'shop_type.dart';

String _randomKey() {
  String id = '';
  String options = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  Random rand = Random();
  for (int i = 0; i < 2; i++) {
    id += options[rand.nextInt(options.length)];
  }
  return id;
}

class Business {
  final String id;

  final ShopType shopType;

  final int size;

  String get name => shopTypeName(shopType);

  Color get color => shopTypeColor(shopType);

  int get maxSize => shopTypeMaxSize(shopType);

  int get value => businessValue(shopType, size);

  Business.create(this.shopType, this.size) : id = _randomKey();

  Business(this.id, this.shopType, this.size);

  @override
  String toString() {
    return shopTypeName(shopType) + ' ×' + size.toString();
  }
}
