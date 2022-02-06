import 'business.dart';

class Board {
  final int minPropertyNumber = 1;
  final int maxPropertyNumber = 85;

  final Map<int, String> _propertyOwnerIds = {};

  final Map<int, ShopType> _propertyShops = {};

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
}
