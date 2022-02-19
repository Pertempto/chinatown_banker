import 'package:hive/hive.dart';

import 'business.dart';

part 'board.g.dart';

@HiveType(typeId: 8)
class Board {
  final int minPropertyNumber = 1;
  final int maxPropertyNumber = 85;

  @HiveField(0)
  final Map<int, String> _propertyOwnerIds;

  @HiveField(1)
  final Map<int, ShopType> _propertyShops;

  Map<int, String> get propertyOwnerIds => Map.from(_propertyOwnerIds);
  Map<int, ShopType> get propertyShops => Map.from(_propertyShops);

  Board()
      : _propertyOwnerIds = {},
        _propertyShops = {};

  Board.from(this._propertyOwnerIds, this._propertyShops);

  setOwnerId(int propertyNumber, String? ownerId) {
    if (checkPropertyNumber(propertyNumber)) {
      if (ownerId == null) {
        _propertyOwnerIds.remove(propertyNumber);
      } else {
        _propertyOwnerIds[propertyNumber] = ownerId;
      }
    }
  }

  String? getOwnerId(int propertyNumber) {
    return _propertyOwnerIds[propertyNumber];
  }

  setShopType(int propertyNumber, ShopType? shopType) {
    if (checkPropertyNumber(propertyNumber)) {
      if (shopType == null) {
        _propertyShops.remove(propertyNumber);
      } else {
        _propertyShops[propertyNumber] = shopType;
      }
    }
  }

  ShopType? getShopType(int propertyNumber) {
    return _propertyShops[propertyNumber];
  }

  bool checkPropertyNumber(int propertyNumber) {
    return propertyNumber >= minPropertyNumber && propertyNumber <= maxPropertyNumber;
  }

  set(Board board) {
    _propertyOwnerIds.clear();
    board.propertyOwnerIds.forEach((propertyNumber, ownerId) {
      setOwnerId(propertyNumber, ownerId);
    });
    _propertyShops.clear();
    board.propertyShops.forEach((propertyNumber, shopType) {
      setShopType(propertyNumber, shopType);
    });
  }

  Board copy() {
    return Board.from(Map.from(_propertyOwnerIds), Map.from(_propertyShops));
  }
}
