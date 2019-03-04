import 'package:cashwave/data/database.dart';
import 'package:cashwave/data/item.dart';

/**
 * ID в базе это "id_" + id
 * Потому что сейчас флаттер (или я) тупой
 */
class Repository {
  static final Repository _repo = new Repository._internal();

  ItemDatabase database;

  static Repository get() {
    return _repo;
  }

  Repository._internal() {
    database = ItemDatabase.get();
  }

  Future init() async {
    return await database.init();
  }

  Future updateItem(Item item) async {
    item.idItem = "id_" + item.idItem;
    await database.updateItem(item);
  }

  Future<Item> getItem(String id) async {
    Item item = await database.getItem("id_" + id);
    item.idItem = item.idItem.substring(3);
    return item;
  }

  Future<List<Item>> getItems() async {
    List<Item> items = await database.getAllItems();
    items.forEach((item) {
      item.idItem = item.idItem.substring(3);
    });
    return items;
  }

  Future<List<Item>> removeItem(String id) async {
    List<Item> items = await database.removeItem("id_" + id);
    items.forEach((item) {
      item.idItem = item.idItem.substring(3);
    });
    return items;
  }

  Future close() async {
    return database.close();
  }
}
