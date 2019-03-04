import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'item.dart';

class ItemDatabase {
  static final ItemDatabase _bookDatabase = new ItemDatabase._internal();

  final String tableName = "Items";

  Database db;

  bool didInit = false;

  static ItemDatabase get() {
    return _bookDatabase;
  }

  ItemDatabase._internal();

  /// Use this method to access the database, because initialization of the database (it has to go through the method channel)
  Future<Database> _getDb() async {
    if (!didInit) await _init();
    return db;
  }

  Future init() async {
    return await _init();
  }

  Future _init() async {
    // Get a location using path_provider
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "demo.db");
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute("CREATE TABLE $tableName ("
          "${Item.DB_ITEM_ID} STRING PRIMARY KEY,"
          "${Item.DB_NAME} TEXT,"
          "${Item.DB_COST} INTEGER,"
          "${Item.DB_WEIGHT} INTEGER"
          ")");
    });
    didInit = true;
  }

  /// Get a book by its id, if there is not entry for that ID, returns null.
  Future<Item> getItem(String id) async {
    var db = await _getDb();
    var result = await db
        .rawQuery('SELECT * FROM $tableName WHERE ${Item.DB_ITEM_ID} = "$id"');
    if (result.length == 0) return null;
    return new Item.fromMap(result[0]);
  }

  /// Get all books with ids, will return a list with all the books found
  Future<List<Item>> getItems(List<String> ids) async {
    var db = await _getDb();
    // Building SELECT * FROM TABLE WHERE ID IN (id1, id2, ..., idn)
    var idsString = ids.map((it) => '"$it"').join(',');
    var result = await db.rawQuery(
        'SELECT * FROM $tableName WHERE ${Item.DB_ITEM_ID} IN ($idsString)');
    List<Item> items = [];
    for (Map<String, dynamic> item in result) {
      items.add(new Item.fromMap(item));
    }
    return items;
  }

  Future<List<Item>> removeItem(String id) async {
    var db = await _getDb();
    var resut = await db
        .delete(tableName, where: "${Item.DB_ITEM_ID} = ?", whereArgs: [id]);
    var result = await db.rawQuery('SELECT * FROM $tableName');
    List<Item> items = [];
    for (Map<String, dynamic> item in result) {
      items.add(new Item.fromMap(item));
    }
    return items;
  }

  Future<List<Item>> getAllItems() async {
    var db = await _getDb();
    var result = await db.rawQuery('SELECT * FROM $tableName');
    List<Item> items = [];
    for (Map<String, dynamic> item in result) {
      items.add(new Item.fromMap(item));
    }
    return items;
  }

  //TODO escape not allowed characters eg. ' " '
  Future updateItem(Item item) async {
    var db = await _getDb();
    await db.rawInsert(
        'INSERT OR REPLACE INTO '
        '$tableName(${Item.DB_ITEM_ID}, ${Item.DB_NAME}, ${Item.DB_COST}, ${Item.DB_WEIGHT})'
        ' VALUES(?, ?, ?, ?)',
        [item.idItem, item.name, item.cost, item.weight]);
  }

  Future close() async {
    var db = await _getDb();
    return db.close();
  }
}
