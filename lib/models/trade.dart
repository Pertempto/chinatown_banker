import 'package:hive/hive.dart';

part 'trade.g.dart';

@HiveType(typeId: 8)
class Trade extends HiveObject {
  @HiveField(0)
  List<String> partyIds;

  @HiveField(1)
  List<TradeItem> tradeItems;

  Trade({
    required this.partyIds,
    required this.tradeItems,
  });
}

@HiveType(typeId: 9)
class TradeItem extends HiveObject {
  @HiveField(0)
  String fromId;

  @HiveField(1)
  String toId;

  @HiveField(2)
  int cash;

  @HiveField(3)
  List<int> propertyNumbers;

  TradeItem({required this.fromId, required this.toId, required this.cash, required this.propertyNumbers});
}
