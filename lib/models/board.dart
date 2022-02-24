import 'dart:math';

import 'package:hive/hive.dart';

import 'business.dart';
import 'shop_type.dart';

part 'board.g.dart';

const List<List<int>> _propertyNumbersGrid = [
  [00, 01, 02, 00, 00, 16, 17, 18, 00, 28, 29, 30, 00, 43, 44, 45, 46],
  [00, 03, 04, 05, 00, 19, 20, 21, 00, 31, 32, 33, 00, 47, 48, 49, 50],
  [06, 07, 08, 09, 00, 22, 23, 00, 00, 34, 35, 36, 00, 51, 52, 53, 54],
  [10, 11, 12, 00, 00, 24, 25, 00, 00, 00, 37, 38, 39, 00, 00, 55, 56],
  [13, 14, 15, 00, 00, 26, 27, 00, 00, 00, 40, 41, 42, 00, 00, 57, 58],
  [00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00, 00],
  [00, 00, 00, 00, 00, 00, 59, 60, 00, 00, 00, 71, 72, 73, 74, 00, 00],
  [00, 00, 00, 00, 00, 00, 61, 62, 00, 00, 00, 75, 76, 77, 78, 00, 00],
  [00, 00, 00, 00, 00, 00, 63, 64, 65, 00, 00, 79, 80, 81, 82, 00, 00],
  [00, 00, 00, 00, 00, 00, 66, 67, 68, 00, 00, 83, 84, 85, 00, 00, 00],
  [00, 00, 00, 00, 00, 00, 00, 69, 70, 00, 00, 00, 00, 00, 00, 00, 00],
];

int getPropertyNumber(int x, int y) {
  return _propertyNumbersGrid[y][x];
}

Map<int, Point<int>> _propertyNumLocations = {};

Point? getPropertyLocation(int propertyNumber) {
  if (_propertyNumLocations.containsKey(propertyNumber)) {
    return _propertyNumLocations[propertyNumber];
  }
  for (int y = 0; y < _propertyNumbersGrid.length; y++) {
    for (int x = 0; x < _propertyNumbersGrid[y].length; x++) {
      if (_propertyNumbersGrid[y][x] == propertyNumber) {
        _propertyNumLocations[propertyNumber] = Point(x, y);
        return _propertyNumLocations[propertyNumber];
      }
    }
  }
  return null;
}

@HiveType(typeId: 6)
class Board {
  final int minPropertyNumber = 1;
  final int maxPropertyNumber = 85;

  @HiveField(0)
  final Map<int, String> propertyOwnerIds;

  @HiveField(1)
  final Map<int, ShopType> propertyShops;

  Board({required this.propertyOwnerIds, required this.propertyShops});

  setOwnerId(int propertyNumber, String? ownerId) {
    if (checkPropertyNumber(propertyNumber)) {
      if (ownerId == null) {
        propertyOwnerIds.remove(propertyNumber);
      } else {
        propertyOwnerIds[propertyNumber] = ownerId;
      }
    }
  }

  String? getOwnerId(int propertyNumber) {
    return propertyOwnerIds[propertyNumber];
  }

  setShopType(int propertyNumber, ShopType? shopType) {
    if (checkPropertyNumber(propertyNumber)) {
      if (shopType == null) {
        propertyShops.remove(propertyNumber);
      } else {
        propertyShops[propertyNumber] = shopType;
      }
    }
  }

  ShopType? getShopType(int propertyNumber) {
    return propertyShops[propertyNumber];
  }

  bool checkPropertyNumber(int propertyNumber) {
    return propertyNumber >= minPropertyNumber && propertyNumber <= maxPropertyNumber;
  }

  set(Board board) {
    propertyOwnerIds.clear();
    board.propertyOwnerIds.forEach((propertyNumber, ownerId) {
      setOwnerId(propertyNumber, ownerId);
    });
    propertyShops.clear();
    board.propertyShops.forEach((propertyNumber, shopType) {
      setShopType(propertyNumber, shopType);
    });
  }

  Board copy() {
    return Board(propertyOwnerIds: Map.from(propertyOwnerIds), propertyShops: Map.from(propertyShops));
  }

  List<Business> businesses(String ownerId) {
    List<int> propertyNumbers = propertyOwnerIds.keys
        .where((propertyNumber) => propertyOwnerIds[propertyNumber] == ownerId && propertyShops[propertyNumber] != null)
        .toList();
    List<List<int>> groups = [];
    while (propertyNumbers.isNotEmpty) {
      int propertyNumber = propertyNumbers.removeLast();
      ShopType shopType = getShopType(propertyNumber)!;
      List<int> group = [propertyNumber];
      List<Point> points = [getPropertyLocation(propertyNumber)!];
      while (true) {
        bool foundMatch = false;
        for (int other in List.from(propertyNumbers)) {
          if (getShopType(other) == shopType) {
            Point otherPoint = getPropertyLocation(other)!;
            bool touching = points.any((point) => point.distanceTo(otherPoint) < 1.1);
            if (touching) {
              foundMatch = true;
              propertyNumbers.remove(other);
              group.add(other);
              points.add(otherPoint);
            }
          }
        }
        if (!foundMatch) {
          break;
        }
      }
      groups.add(group);
    }
    List<Business> businesses = [];
    for (List<int> group in groups) {
      ShopType shopType = getShopType(group[0])!;
      int maxSize = shopTypeMaxSize(shopType);
      int count = group.length;
      while (count > 0) {
        if (count <= maxSize) {
          businesses.add(Business.create(shopType, count));
          count = 0;
        } else {
          businesses.add(Business.create(shopType, maxSize));
          count -= maxSize;
        }
      }
    }
    return businesses;
  }

  Iterable<int> getPropertyNumbers(String ownerId) {
    return propertyOwnerIds.keys.where((propertyNumber) => propertyOwnerIds[propertyNumber] == ownerId);
  }
}
