import 'package:crm/app_const/utils/app_utils.dart';
import 'package:crm/screen/masters/terms/model/terms_model.dart';
import 'package:crm/services/local_db.dart';
import 'package:sqflite/sqflite.dart';

class TermsRepo {
  static const String table = 'terms';

  /// Creates the 'terms' table in the database if it doesn't already exist.
  static Future<void> createTermsTable(Database db) async {
    await db.execute('''
        CREATE TABLE IF NOT EXISTS $table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            isSynced INTEGER DEFAULT 0
        )
    ''');
  }

  /// Inserts a new terms record into the 'terms' table.
  static Future<int> insertTerms(TermsModel terms) async {
    Database db = await DatabaseHelper().database;
    try {
      return await db.insert(
        table,
        terms.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      // Handle the error, e.g., log it or rethrow a custom exception
      AppUtils.showlog('inserting terms: $e');
      rethrow;
    }
  }

  /// Retrieves all terms records from the
  static Future<List<TermsModel>> getAllTerms() async {
    try {
      Database db = await DatabaseHelper().database;
      final result = await db.query(table);
      return result.map((e) => TermsModel.fromJson(e)).toList();
    } catch (e) {
      AppUtils.showlog('retrieving terms: $e');
      rethrow;
    }
  }

  ///delete term
  static Future<void> deleteTerm(int id) async {
    Database db = await DatabaseHelper().database;
    try {
      await db.delete(table, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      AppUtils.showlog('deleting terms: $e');
      rethrow;
    }
  }
}
