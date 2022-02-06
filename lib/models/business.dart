import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'business.g.dart';

String _randomKey() {
  String id = '';
  String options =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  Random rand = Random();
  for (int i = 0; i < 2; i++) {
    id += options[rand.nextInt(options.length)];
  }
  return id;
}

@HiveType(typeId: 5)
class Business {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final ShopType shopType;

  @HiveField(2)
  final int size;

  String get name => shopTypeName(shopType);

  Color get color => shopTypeColor(shopType);

  int get maxSize => shopTypeMaxSize(shopType);

  int get value => businessValue(shopType, size);

  Business.create(this.shopType)
      : id = _randomKey(),
        size = 1;

  Business(this.id, this.shopType, this.size);

  @override
  String toString() {
    return shopTypeName(shopType) + ' ×' + size.toString();
  }
}

String shopTypeName(ShopType shopType) {
  return {
        ShopType.photo: 'Photo',
        ShopType.teaHouse: 'Tea House',
        ShopType.seaFood: 'Sea Food',
        ShopType.jewellery: 'Jewellery',
        ShopType.tropicalFish: 'Tropical Fish',
        ShopType.florist: 'Florist',
        ShopType.takeOut: 'Take Out',
        ShopType.laundry: 'Laundry',
        ShopType.dimSum: 'Dim Sum',
        ShopType.antiques: 'Antiques',
        ShopType.factory: 'Factory',
        ShopType.restaurant: 'Restaurant',
      }[shopType] ??
      '';
}

Color shopTypeColor(ShopType shopType) {
  return {
        ShopType.photo: Colors.lightGreen[500],
        ShopType.teaHouse: Colors.green[900],
        ShopType.seaFood: Colors.lightGreen[700],
        ShopType.jewellery: Colors.lightBlue[500],
        ShopType.tropicalFish: Colors.indigo[900],
        ShopType.florist: Colors.blue[700],
        ShopType.takeOut: Colors.orange[500],
        ShopType.laundry: Colors.brown[800],
        ShopType.dimSum: Colors.deepOrange[800],
        ShopType.antiques: Colors.amber[900],
        ShopType.factory: Colors.brown[500],
        ShopType.restaurant: Colors.yellow[600],
      }[shopType] ??
      Colors.black;
}

int shopTypeMaxSize(ShopType shopType) {
  return {
        ShopType.photo: 3,
        ShopType.teaHouse: 3,
        ShopType.seaFood: 3,
        ShopType.jewellery: 4,
        ShopType.tropicalFish: 4,
        ShopType.florist: 4,
        ShopType.takeOut: 5,
        ShopType.laundry: 5,
        ShopType.dimSum: 5,
        ShopType.antiques: 6,
        ShopType.factory: 6,
        ShopType.restaurant: 6,
      }[shopType] ??
      0;
}

int businessValue(ShopType shopType, int size) {
  bool isComplete = shopTypeMaxSize(shopType) == size;
  if (isComplete) {
    return [0, 0, 0, 50, 80, 110, 140][size];
  } else {
    return [0, 10, 20, 40, 60, 80][size];
  }
}

@HiveType(typeId: 6)
enum ShopType {
  @HiveField(0)
  photo,
  @HiveField(1)
  teaHouse,
  @HiveField(2)
  seaFood,
  @HiveField(3)
  jewellery,
  @HiveField(4)
  tropicalFish,
  @HiveField(5)
  florist,
  @HiveField(6)
  takeOut,
  @HiveField(7)
  laundry,
  @HiveField(8)
  dimSum,
  @HiveField(9)
  antiques,
  @HiveField(10)
  factory,
  @HiveField(11)
  restaurant,
}
