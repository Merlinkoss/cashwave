import 'package:meta/meta.dart';

class Item {
  static const String DB_ITEM_ID = "itemid";
  static const String DB_NAME = "name";
  static const String DB_WEIGHT = "weight";
  static const String DB_COST = "cost";

  String idItem, name;
  int weight, cost;

  Item(
      {@required this.idItem,
      @required this.name,
      @required this.weight,
      @required this.cost});

  Item.fromMap(Map<String, dynamic> map)
      : this(
          idItem: map[DB_ITEM_ID],
          name: map[DB_NAME],
          weight: map[DB_WEIGHT],
          cost: map[DB_COST],
        );

  Map<String, dynamic> toMap() {
    return {
      DB_ITEM_ID: idItem,
      DB_NAME: name,
      DB_WEIGHT: weight,
      DB_COST: cost
    };
  }
}
