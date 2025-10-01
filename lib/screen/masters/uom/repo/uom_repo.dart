import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/screen/masters/uom/model/uom_model.dart';
import 'package:crm/services/local_db.dart';
import 'package:sqflite/sqlite_api.dart';

class UomRepo {
  static const String table = 'uom';

  /// Creates the 'uom' table in the database if it doesn't already exist.
  static Future<void> createUomTable(Database db) async {
    await db.execute('''
        CREATE TABLE IF NOT EXISTS $table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            code TEXT,
            isSynced INTEGER
        )
    ''');
  }

  ///insert a new record
  static Future<int> insertUom(UomModel uom) async {
    Database db = await DatabaseHelper().database;
    try {
      return await db.insert(
        table,
        uom.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      // Handle the error, e.g., log it or rethrow a custom exception
      showlog('inserting uom: $e');
      rethrow;
    }
  }

  ///retrive all uom
  static Future<List<UomModel>> getAllUom() async {
    try {
      Database db = await DatabaseHelper().database;
      final result = await db.query(table);
      return result.map((e) => UomModel.fromJson(e)).toList();
    } catch (e) {
      showlog('retrieving uom: $e');
      rethrow;
    }
  }

  ///delete uom
  static Future<void> deleteUom(int id) async {
    Database db = await DatabaseHelper().database;
    try {
      await db.delete(table, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      showlog('deleting uom: $e');
      rethrow;
    }
  }
}
