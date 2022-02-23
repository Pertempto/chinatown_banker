import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'shop_type.g.dart';

@HiveType(typeId: 7)
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
        ShopType.antiques: const Color(0xFF84754A),
        ShopType.factory: Colors.brown[500],
        ShopType.restaurant: const Color(0xFF785D0B),
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
